class LinebotController < ApplicationController
  protect_from_forgery except: :sort

  # require 'selenium-webdriver'
  # require 'webdrivers'

  # Selenium::WebDriver::Chrome.path = ENV.fetch('GOOGLE_CHROME_BIN')

  # def headless_options
  #   options = Selenium::WebDriver::Chrome::Options.new
  #   options.binary = ENV.fetch('GOOGLE_CHROME_SHIM')
  #   options.add_argument('headless')
  #   options.add_argument('disable-gpu')
  #   options
  # end

  def callback
    body = request.body.read
    events = client.parse_events_from(body)

    events.each do |event|
      require 'open-uri'
      case event
      when Line::Bot::Event::Follow
        line_id = event["source"]["userId"]
        user = User.new(line_id: line_id)
        if user.save
          message = {
            type: 'text',
            text: "ユーザー登録完了しました。"
          }
          client.reply_message(event['replyToken'], message)
        end
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          req_message = event.message['text']
          # user_id = event['source']['userId']
          response = req_message
          # if req_message.include?('登録')
          #   arr = req_message.split("　")
          #   # 商品名とURL取得
          #   # item_name = arr[1]
          #   # item_url = arr[2]
          #   # 商品価格取得
          #   # browser = Selenium::WebDriver.for :chrome, options: headless_options
          #   # browser.get item_url
          #   #price = browser.find_element(:id, 'priceblock_ourprice').text
          #   browser.quit
          #   # Itemデータ作成
          #   user = User.find_by(line_id: user_id)
          #   item = user.items.create(name: item_name, url: item_url, price: price)
          #   # レスポンス
          #   response = "商品名「#{item.name}」を登録しました。\n現在の価格:#{item.price}\n参照URL「#{item.url}」"
          # elsif req_message.include?('リスト')
          #   user = User.find_by(line_id: user_id)
          #   items = user.items
          #   response = "登録商品リスト\n"
          #   items.each do |item|
          #     response << "#{item.name}:#{item.price}\n"
          #   end
          # end
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    "OK"
  end

  def push

  end

end
