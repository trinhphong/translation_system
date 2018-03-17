class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def read_src_file(path)
    src = ''
    File.open(path, "r") do |f|
      src =  f.readline
    end
    src
  end

  def read_tgt_file(path)
    tgt = ''
    File.open(path, "r") do |f|
      tgt =  f.readline
    end
    tgt
  end

  def read_bleu_file(path)
    bleu = ''
    File.open(path, "r") do |f|
      bleu =  f.readline
    end
    res = bleu.match(/[0-9]*\.[0-9]{2}|^[0-9]*\.[0-9]{2}[^0-9]/)
  end
end
