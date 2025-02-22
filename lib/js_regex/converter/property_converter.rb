# frozen_string_literal: true

require_relative 'base'
require 'character_set'

class JsRegex
  module Converter
    #
    # Template class implementation.
    #
    # Uses the `character_set` and `regexp_property_values` gems to get the
    # codepoints matched by the property and build a set string from them.
    #
    class PropertyConverter < JsRegex::Converter::Base
      private

      def convert_data
        content = character_set_of_property

        if expression.negative?
          if content.astral_part?
            warn_of_unsupported_feature('astral plane negation by property')
          end
        elsif Converter.in_surrogate_pair_limit? { content.astral_part.size }
          return content.to_s_with_surrogate_alternation
        else
          warn_of_unsupported_feature('large astral plane match of property')
        end

        limit_to_bmp_part(content)
      end

      def character_set_of_property
        character_set = CharacterSet.of_property(subtype)
        if expression.case_insensitive? && !context.case_insensitive_root
          character_set.case_insensitive
        else
          character_set
        end
      end

      def limit_to_bmp_part(content)
        bmp_part = content.bmp_part
        return drop if bmp_part.empty?

        "[#{'^' if expression.negative?}#{bmp_part}]"
      end
    end
  end
end
