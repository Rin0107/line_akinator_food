class AkinatorController < ApplicationController
    protect_from_forgery except: [:food]

    def food
        body = request.body.read

        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
            return head :bad_request
        end

        events = client.parse_events_from(body)
        # メッセージのtype,userId,message等の情報を連想配列でeventsに代入
        events.each do |event|
            case event
                when Line::Bot::Event::Message
                    case event.type
                        when Line::Bot::Event::MessageType::Text
                            message = {
                                type: 'text',
                                text: event.message['text']
                            }
                            client.reply_message(event['replyToken'], message)
                    end
            end
        end
        head :ok
    end

    private
        def client
            @client ||= Line::Bot::Client.new { |config|
                config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
                config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
              }
        end
end
