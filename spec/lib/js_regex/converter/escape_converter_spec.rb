# frozen_string_literal: true

#
#
#
# WARNING: Some of the examples below contain literal tabs.
# Make sure that your IDE doesn't replace them with spaces.
#
#
#

require 'spec_helper'

describe JsRegex::Converter::EscapeConverter do
  it 'lets backslashes pass through' do
    expect(/\\/).to stay_the_same.and keep_matching('\\', with_results: %w[\\])
  end

  it 'preserves escaped groups' do
    expect(/\(1\)/).to stay_the_same
  end

  it 'preserves escaped literals' do
    expect(/\j/).to stay_the_same.and keep_matching('ijk', with_results: %w[j])
  end

  it 'preserves escaped dots' do
    expect(/\./).to stay_the_same.and keep_matching('a.b', with_results: %w[.])
  end

  it 'preserves escaped quantifiers' do
    expect(/\?\*\+/).to stay_the_same.and keep_matching('a?*+b', with_results: %w[?*+])
  end

  it 'preserves null escapes' do
    expect(/\0/).to stay_the_same.and keep_matching("\x00", with_results: %W[\x00])
  end

  it 'preserves newline escapes' do
    expect(/\n/).to stay_the_same.and keep_matching("a\nb", with_results: %W[\n])
  end

  it 'preservers carriage return escapes' do
    expect(/\r/).to stay_the_same.and keep_matching("abc\r123", with_results: %W[\r])
  end

  it 'preserves vertical tab escapes' do
    expect(/\t/).to stay_the_same.and keep_matching("a\tb", with_results: %W[\t])
  end

  it 'preserves horizontal tab escapes' do
    expect(/\v/).to stay_the_same.and keep_matching("a\vb", with_results: %W[\v])
  end

  it 'preserves form feed escapes' do
    expect(/\f/).to stay_the_same.and keep_matching("a\fb", with_results: %W[\f])
  end

  it 'preserves escaped interval brackets' do
    expect(/\{\}/).to stay_the_same.and keep_matching('a{}b', with_results: %w[{}])
  end

  it 'preserves escaped set brackets' do
    expect(/\[\]/).to stay_the_same
  end

  it 'preserves escaped alternation chars' do
    expect(/\|/).to stay_the_same
      .and keep_matching('a|b', with_results: %w[|])
  end

  it 'preserves escaped meta chars / types' do
    expect(/\\h\\H\\s\\S\\d\\D\\w\\W/).to stay_the_same
      .and keep_matching('h\\h\\H\\s\\S\\d\\D\\w\\W',
                         with_results: %w[\\h\\H\\s\\S\\d\\D\\w\\W])
  end

  it 'preserves escaped bol/eol anchors' do
    expect(/\^\$/).to stay_the_same
      .and keep_matching('^$', with_results: %w[^$])
  end

  it 'preserves escaped bos/eos anchors' do
    expect(/\\A\\z\\Z/).to stay_the_same
      .and keep_matching('A\\A\\z\\Z', with_results: %w[\\A\\z\\Z])
  end

  it 'lets ascii escapes pass through' do
    expect(/\x42/).to stay_the_same.and keep_matching('ABC', with_results: %w[B])
  end

  it 'lets unicode / codepoint escapes pass through' do
    expect(/\u263A/).to stay_the_same.and keep_matching('A☺C', with_results: %w[☺])
  end

  it 'lets octal escapes pass through' do
    expect(/\177/).to stay_the_same.and keep_matching("a\177b", with_results: %W[\177])
  end

  it 'replaces escaped literal tabs with \t' do
    expect(/\	/).to\
    become(/\t/).and keep_matching('	', with_results: ['	'])
  end

  it 'replaces the bell char "\a" with a hex escape' do
    expect(/.\a/).to\
    become(/.\x07/).and keep_matching("ab\ac", with_results: ["b\a"])
  end

  it 'replaces the escape char "\e" with a hex escape' do
    expect(/.\e/).to\
    become(/.\x1B/).and keep_matching("ab\ec", with_results: ["b\e"])
  end

  it 'converts codepoint lists, escaping meta chars and using surrogates' do
    expect(/\u{61 a 28 1F601}/).to\
    become(double(source: 'a\n\((?:\ud83d\ude01)'))
      .and keep_matching("_a\n(😁_", with_results: %W[a\n(😁])
  end

  it 'places quantifiers at the end of codepoint list conversions' do
    expect(/\u{61 62 63}+/).to\
    become(/abc+/).and keep_matching('_abca_abcc_', with_results: %w[abc abcc])
  end

  it 'converts the control sequences style "\C-X" to unicode escapes' do
    expect(/.\C-*/).to\
    become(/.\u000A/).and keep_matching("ya\ny", with_results: %W[a\n])
  end

  it 'converts the control sequences style "\cX" to unicode escapes' do
    expect(/.\c*/).to\
    become(/.\u000A/).and keep_matching("ya\ny", with_results: %W[a\n])
  end

  it 'converts the meta sequences style "\M-X" to unicode escapes' do
    expect(/.\M-X/n).to\
    become(/.\u00D8/)
  end

  it 'converts the meta control sequences style "\M-\C-X" to unicode escapes' do
    expect(/.\M-\C-X/n).to\
    become(/.\u0098/)
  end

  it 'converts the meta control sequences style "\M-\cX" to unicode escapes' do
    expect(/.\M-\cX/n).to\
    become(/.\u0098/)
  end

  it 'converts the meta control sequences style "\C-\M-X" to unicode escapes' do
    expect(/.\C-\M-X/n).to\
    become(/.\u0098/)
  end

  it 'converts the meta control sequences style "\c\M-X" to unicode escapes' do
    expect(/.\c\M-X/n).to\
    become(/.\u0098/)
  end

  it 'drops unknown escapes with warning' do
    expect([:escape, :unknown]).to be_dropped_with_warning
  end
end
