# frozen_string_literal: true

RSpec.describe "the github provider" do
  around do |example|
    saved = ENV.to_h.slice("GH_TOKEN", "GITHUB_TOKEN", "GITHUB_BASE_URL", "GITHUB_MODEL")
    example.run
  ensure
    %w[GH_TOKEN GITHUB_TOKEN GITHUB_BASE_URL GITHUB_MODEL].each { |k| ENV.delete(k) }
    ENV.update(saved)
  end

  before do
    ENV.delete("GH_TOKEN")
    ENV["GITHUB_TOKEN"] = "test-key"
    ENV["GITHUB_MODEL"] = "env-model"
    ENV.delete("GITHUB_BASE_URL")
  end

  def build(**) = Elelem::Config.build_provider("github", **)
  def uri(**) = build(**).instance_variable_get(:@uri).to_s
  def model(**) = build(**).instance_variable_get(:@model)
  def key = build.instance_variable_get(:@api_key)

  it "registers provider github" do
    expect(Elelem::Config.names).to include("github")
    expect(build).to be_a(Elelem::OpenAI::Provider)
  end

  it "talks to GitHub by default" do
    expect(uri).to eq("https://models.github.ai/inference/chat/completions")
  end

  it "sends GITHUB_TOKEN" do
    expect(key).to eq("test-key")
  end

  it "prefers GH_TOKEN over GITHUB_TOKEN, as gh does" do
    ENV["GH_TOKEN"] = "gh-key"
    expect(key).to eq("gh-key")
  end

  it "names both variables when the token is missing or empty" do
    ENV.delete("GITHUB_TOKEN")
    expect { build }.to raise_error(KeyError, /GH_TOKEN or GITHUB_TOKEN/)

    ENV["GITHUB_TOKEN"] = " "
    ENV["GH_TOKEN"] = ""
    expect { build }.to raise_error(KeyError, /GH_TOKEN or GITHUB_TOKEN/)
  end

  it "names GITHUB_MODEL when no model is set, and treats an empty one as unset" do
    ENV.delete("GITHUB_MODEL")
    expect { build }.to raise_error(KeyError, /GITHUB_MODEL/)

    ENV["GITHUB_MODEL"] = ""
    expect { build }.to raise_error(KeyError, /GITHUB_MODEL/)
  end

  it "takes the model from GITHUB_MODEL" do
    expect(model).to eq("env-model")
  end

  it "prefers --model over GITHUB_MODEL" do
    expect(model(model: "flag-model")).to eq("flag-model")
  end

  it "uses GITHUB_BASE_URL, with or without a trailing slash, and treats an empty one as unset" do
    ENV["GITHUB_BASE_URL"] = "http://127.0.0.1:8080/v1/"
    expect(uri).to eq("http://127.0.0.1:8080/v1/chat/completions")

    ENV["GITHUB_BASE_URL"] = "http://127.0.0.1:8080/v1"
    expect(uri).to eq("http://127.0.0.1:8080/v1/chat/completions")

    ENV["GITHUB_BASE_URL"] = ""
    expect(uri).to eq("https://models.github.ai/inference/chat/completions")
  end
end
