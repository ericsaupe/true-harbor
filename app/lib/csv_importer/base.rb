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
      converter = lambda { |header| header.downcase.delete(" ").gsub(/#/, "") }
      CSV.foreach(file, headers: true, header_converters: converter) do |row|
        parse_row(row)
      end
    end

    def parse_row(_row)
      raise NotImplementedError
    end
  end
end