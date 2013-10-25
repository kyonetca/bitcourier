module Protocol
  module Message
    class Base
      MAGIC_BYTES = 0x1234

      def header
        [MAGIC_BYTES, self.class::ID, payload.size].pack('SSS')
      end

      def pack
         header + payload
      end

      def self.unpack data
        magic, id, len = unpack_header(data)

        return nil if magic != MAGIC_BYTES # wrong magic
        return nil if len + 6 > data.size # partial package

        klass = find_message_class(id)

        klass.unpack data[6..-1]
      end

      private

      def self.unpack_header data
        data[0..5].unpack('SSS')
      end

      def self.find_message_class id
        [Version].each do |msg|
          return msg if msg::ID == id
        end

        return nil
      end
    end
  end
end
