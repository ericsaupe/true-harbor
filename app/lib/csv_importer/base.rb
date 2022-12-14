# frozen_string_literal: true

require "csv"

module CsvImporter
  class Base
    attr_reader :organization, :file

    class << self
      def import(organization, file)
        new(organization, file).import
      end
    end

    def initialize(organization, file)
      @organization = organization
      @file = file
    end

    def import
      converter = lambda do |header|
        header.downcase.delete(" ")
          .gsub(/#/, "") # hashtags
          .gsub(/[\u200B-\u200D\uFEFF]/, "") # weird blank characters
          .gsub(/[^[:print:]]/, "") # any non-print character
      end
      CSV.foreach(file, headers: true, header_converters: converter) do |row|
        parse_row_async(row.to_h.compact)
      end
    end

    def parse_row_async(row)
      ParseRowJob.perform_async(self.class.name, @organization.id, row)
    end

    def parse_row(_row)
      raise NotImplementedError
    end
  end
end
