#!/usr/bin/env ruby
# frozen_string_literal: true

STYLE_PATH = File.expand_path('../assets/css/style.scss', __dir__)

def hex_to_rgb(hex)
  h = hex.delete('#')
  [h[0..1], h[2..3], h[4..5]].map { |pair| pair.to_i(16) / 255.0 }
end

def linearize(c)
  c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055)**2.4
end

def relative_luminance(hex)
  r, g, b = hex_to_rgb(hex).map { |c| linearize(c) }
  (0.2126 * r) + (0.7152 * g) + (0.0722 * b)
end

def contrast_ratio(fg, bg)
  l1 = relative_luminance(fg)
  l2 = relative_luminance(bg)
  light = [l1, l2].max
  dark = [l1, l2].min
  (light + 0.05) / (dark + 0.05)
end

content = File.read(STYLE_PATH)
root_match = content.match(/:root\s*\{(?<body>.*?)\n\}/m)
abort('Could not find :root token block in assets/css/style.scss') unless root_match

tokens = {}
root_match[:body].scan(/--([a-z0-9-]+):\s*(#[0-9a-fA-F]{6})\s*;/) do |name, value|
  tokens["--#{name}"] = value.downcase
end

def resolve_color(value, tokens)
  return value.downcase if value.start_with?('#')

  tokens.fetch(value) { raise "Missing token: #{value}" }
end

checks = [
  # Text contrast (WCAG AA normal text >= 4.5:1)
  ['Body text on page background', '--text', '--bg', 4.5],
  ['Body text on surface', '--text', '--surface', 4.5],
  ['Muted text on surface', '--muted', '--surface', 4.5],
  ['Accent link text on surface', '--accent', '--surface', 4.5],
  ['Tag/Pill text on weak accent', '--accent-ink', '--accent-weak', 4.5],
  ['Primary button text on accent', '#ffffff', '--accent', 4.5],
  ['Primary button text on accent-2', '#ffffff', '--accent-2', 4.5],
  ['Primary button text on accent-hover', '#ffffff', '--accent-hover', 4.5],
  ['Primary button text on accent-active', '#ffffff', '--accent-active', 4.5],
  ['Disabled control text on disabled bg', '--disabled-text', '--disabled-bg', 4.5],

  # Non-text contrast (WCAG 1.4.11 >= 3:1)
  ['Focus ring on surface', '--ring', '--surface', 3.0],
  ['Control border on surface', '--control-border', '--surface', 3.0],
  ['Primary button border/accent on surface', '--accent', '--surface', 3.0],
  ['Secondary button border on surface', '--accent', '--surface', 3.0]
]

failures = []

puts 'Running contrast audit from tokens in assets/css/style.scss...'
checks.each do |label, fg_ref, bg_ref, minimum|
  fg = resolve_color(fg_ref, tokens)
  bg = resolve_color(bg_ref, tokens)
  ratio = contrast_ratio(fg, bg)
  result = ratio >= minimum ? 'PASS' : 'FAIL'
  puts format('%-5s %-52s ratio=%0.2f required>=%0.1f (%s on %s)', result, label, ratio, minimum, fg_ref, bg_ref)
  failures << [label, ratio, minimum] if ratio < minimum
end

if failures.any?
  warn "\nContrast audit failed: #{failures.length} check(s) below threshold."
  exit 1
end

puts "\nContrast audit passed: #{checks.length} checks satisfied."
