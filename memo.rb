# frozen_string_literal: true

class Memo
  CSV_NAME = 'data.csv'
  attr_accessor :id, :title, :body

  def initialize(title:, body:, id: 'save')
    @id    = id
    @title = id == 'save' ? Memo.escape(title) : title
    @body  = id == 'save' ? Memo.escape(body)  : body
  end

  def save
    datas = Memo.read_csv
    datas.push([SecureRandom.hex(20), title, body])
    Memo.write_csv(datas)
  end

  def update(title:, body:)
    title = Memo.escape(title)
    body  = Memo.escape(body)
    datas = Memo.read_csv
    datas.map! do |data|
      data[0] == id ? [id, title, body] : data
    end
    Memo.write_csv(datas)
  end

  def destory
    datas = Memo.read_csv
    datas.delete_if { |data| data[0] == id }
    Memo.write_csv(datas)
  end

  class << self
    def all
      Memo.read_csv.map! { |data| Memo.new(id: data[0], title: data[1], body: data[2]) }
    end

    def find(id)
      id = Memo.escape(id)
      CSV.foreach(CSV_NAME) do |row|
        return Memo.new(id: row[0], title: row[1], body: row[2]) if row[0] == id
      end
    end

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
