module Rpush
  module Daemon
    module Wns
      class ToastImageRequest
        def self.create(notification, access_token)
          body = ToastImageRequestPayload.new(notification).to_xml
          uri  = URI.parse(notification.uri)
          post = Net::HTTP::Post.new(
            uri.request_uri,
            "Content-Length" => body.length.to_s,
            "Content-Type" => "text/xml",
            "X-WNS-Type" => "wns/toast",
            "X-WNS-RequestForStatus" => "true",
            "Authorization" => "Bearer #{access_token}"
          )
          post.body = body
          post
        end
      end

      class ToastImageRequestPayload
        def initialize(notification)
          @title = notification.data['title'] || ''
          @body = notification.data['body'] || ''
          @launch = notification.data['launch'] || ''
          @image = notification.data['image'] || ''
          @sound = notification.sound unless notification.sound.eql?("default".freeze)
        end

        def to_xml
          launch_string = '' unless @launch
          launch_string = " launch='#{CleanParamString.clean(@launch)}'" if @launch
          audio_string = '' unless @sound
          audio_string = "<audio src='#{CleanParamString.clean(@sound)}'/>" if @sound
          image_string = '' unless @image
          image_string = "<image src='#{CleanParamString.clean(@image)}'/>" if @image
          "<toast#{launch_string}>
            <visual version='1' lang='en-US'>
              <binding template='ToastImageAndText02'>
                <text id='1'>#{CleanParamString.clean(@title)}</text>
                <text id='2'>#{CleanParamString.clean(@body)}</text>
                #{image_string}
              </binding>
            </visual>
            #{audio_string}
          </toast>"
        end
      end

      class CleanParamString
        def self.clean(string)
          string.gsub(/&/, "&amp;").gsub(/</, "&lt;") \
            .gsub(/>/, "&gt;").gsub(/'/, "&apos;").gsub(/"/, "&quot;")
        end
      end
    end
  end
end
