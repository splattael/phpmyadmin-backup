require 'phpmyadmin/backup/version'
require 'mechanize'
require 'logger'

module Phpmyadmin
  class Backup
    attr_reader :agent, :last_page

    def initialize(host, username, password)
      @host = host
      @agent = create_agent
      @last_page = nil
      login(username, password)
    end

    def export(database_names=[])
      export_url = last_page.search("#li_export a").first['href']

      get export_url do |page|
        dump_form = page.form_with :name => 'dump'
        if database_names.empty?
          database_names = dump_form.field_with(:name => 'db_select[]').options
        end
        database_names.each do |database_name|
          filename = export_single(export_url, database_name)
          yield filename if block_given?
        end
      end
    end

    private

    def export_single(export_url, database_name)
      get export_url do |page|
        dump_form = page.form_with :name => 'dump'
        dump_form.field_with(:name => 'db_select[]').value = database_name
        dump_form.checkbox_with(:name => 'asfile').checked = true
        dump_form.field_with(:name => 'filename_template').value = "#{timestamp}.#{database_name}"
        dump_form.radiobutton_with(:name => 'compression').value = 'bzip'
        result = submit(dump_form)
        result.filename
      end
    end

    def create_agent
      agent = Mechanize.new
      agent.log = Logger.new $stderr if $DEBUG
      agent.pluggable_parser.default = Mechanize::FileSaver
      agent.keep_alive = false
      agent.agent.ignore_bad_chunking = true
      agent
    end

    def login(username, password)
      get url do |page|
        login_form = page.form_with :name => 'login_form'
        login_form.field_with(:name => 'pma_username').value = username
        login_form.field_with(:name => 'pma_password').value = password

        submit login_form
      end

      frame = last_page.frame_with(:src => /main/)
      get frame.src do |page|
        unless page.search("#li_user_info").text.include?(username)
          error! "user #{username} not found"
        end
      end
    end

    def get(url)
      @last_page = agent.get url
      if block_given?
        yield @last_page
      else
        @last_page
      end
    end

    def submit(*args)
      @last_page = agent.submit *args
      if block_given?
        yield @last_page
      else
        @last_page
      end
    end

    def url(ext=nil)
      @host + ext.to_s
    end

    def error!(message)
      raise ArgumentError, message
    end

    def timestamp
      @timestamp ||= Time.new.strftime("%Y-%m-%dT%T")
    end
  end
end
