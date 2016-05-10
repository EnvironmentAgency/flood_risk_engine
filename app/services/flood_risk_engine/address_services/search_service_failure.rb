module FloodRiskEngine
  module AddressServices

    class SearchServiceFailure

      attr_accessor :exception

      def initialize(ex)
        @exception = ex
      end

      def self.build(ex)
        Airbrake.notify(ex) if defined? Airbrake

        Rails.logger.error "Address lookup service failed: #{ex}"

        SearchServiceFailure.new(ex)
      end
    end

  end
end
