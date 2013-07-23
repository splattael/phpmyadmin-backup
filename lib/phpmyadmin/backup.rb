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

    def export
      export_url = last_page.search("#li_export a").first['href']
      get export_url do |page|
        dump_form = page.form_with :name => 'dump'
        dump_form.field_with(:name => 'db_select[]').select_all
        dump_form.checkbox_with(:name => 'asfile').checked = true
        submit(dump_form).save 'foo.bar'
      end
    end

    private

    def create_agent
      agent = Mechanize.new
      agent.log = Logger.new $stderr
      agent.pluggable_parser.default = Mechanize::FileSaver
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
      yield @last_page if block_given?
      @last_page
    end

    def submit(*args)
      @last_page = agent.submit *args
      yield @last_page if block_given?
      @last_page
    end

    def url(ext=nil)
      @host + ext.to_s
    end

    def error!(message)
      raise ArgumentError, message
    end
  end
end

if $0 == __FILE__
  host, username, password = *ARGV
  backup = Phpmyadmin::Backup.new(host, username, password)
  backup.export
end
