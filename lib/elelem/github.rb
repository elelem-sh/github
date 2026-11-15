# frozen_string_literal: true

require "elelem/openai"

require_relative "github/version"

Elelem.configure do |config|
  config.provider(:github) do |model: nil, **|
    # A variable that is set but empty counts as unset.
    env = ->(name) { ENV[name].to_s.strip.then { |v| v.empty? ? nil : v } }
    key = env.call("GITHUB_API_KEY")
    raise KeyError, "GITHUB_API_KEY is not set" if key.nil?

    model = env.call("GITHUB_MODEL") if model.to_s.strip.empty?
    raise KeyError, "GITHUB_MODEL is not set. Pass --model or set GITHUB_MODEL" if model.nil?

    Elelem::OpenAI::Provider.new(
      model:,
      api_key: key,
      base_url: env.call("GITHUB_BASE_URL") || "https://models.github.ai/inference"
    )
  end
end
