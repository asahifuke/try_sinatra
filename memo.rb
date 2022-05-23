# frozen_string_literal: true

class Memo
  CSV_NAME = 'data.csv'
  attr_accessor :id, :title, :body

  def self.all
    read_csv.map! { |data| Memo.new(id: data[0], title: data[1], body: data[2]) }
  end

  def self.find(id)
    id = escape(id)
    CSV.foreach(CSV_NAME) do |row|
      return Memo.new(id: row[0], title: row[1], body: row[2]) if row[0] == id
    end
  end

  def initialize(title:, body:, id: 'save')
    @id    = id
    @title = id == 'save' ? escape(title) : title
    @body  = id == 'save' ? escape(body)  : body
  end

  def save
    datas = read_csv
    datas.push([SecureRandom.hex(20), title, body])
    write_csv(datas)
  end

  def update(title:, body:)
    title = escape(title)
    body  = escape(body)
    datas = read_csv
    datas.map! do |data|
      data[0] == id ? [id, title, body] : data
    end
    write_csv(datas)
  end

  def destory
    datas = read_csv
    datas.delete_if { |data| data[0] == id }
    write_csv(datas)
  end

  private

  def write_csv(datas)
    CSV.open(CSV_NAME, 'wb') do |csv|
      datas.each { |data| csv << data }
    end
  end

  def read_csv
    CSV.read(CSV_NAME)
  end

  def escape(text)
    escape_characters = {
      '&' => '&amp;',
      '<' => '&lt;',
      '>' => '&gt;',
      '\'' => '&quot;',
      '"' => '&#39;'
    }
    escape_characters.each do |key, value|
      text.gsub!(key, value)
    end
    text
  end

  class << self
    private

    def write_csv(datas)
      CSV.open(CSV_NAME, 'wb') do |csv|
        datas.each { |data| csv << data }
      end
    end

    def read_csv
      CSV.read(CSV_NAME)
    end

    def escape(text)
      escape_characters = {
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
        '\'' => '&quot;',
        '"' => '&#39;'
      }
      escape_characters.each do |key, value|
        text.gsub!(key, value)
      end
      text
    end
  end
end
