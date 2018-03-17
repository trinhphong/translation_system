class TranslateController < ApplicationController
  def index
    @src_nmt = read_src_file "/home/trinhphong/Desktop/nmt/run/input.en"
    @tgt_nmt = read_tgt_file "/home/trinhphong/Desktop/nmt/run/output_infer"

    @src_smt = read_src_file "/home/trinhphong/moses/run/input.en"
    @tgt_smt = read_tgt_file "/home/trinhphong/moses/run/output_infer"

    @expect_tgt  = read_src_file "/home/trinhphong/translate_system/expect/expect"

    @bleu_nmt = read_bleu_file "/home/trinhphong/translate_system/expect/bleu.nmt"
    @bleu_smt = read_bleu_file "/home/trinhphong/translate_system/expect/bleu.smt"
  end

  def translate
    translate_nmt
    translate_smt
    clear_bleu
    redirect_to root_path
  end

  def mark
    ef = File.open("/home/trinhphong/translate_system/expect/expect", "w+")
    ef.write params[:expect_tgt]
    ef.close

    `~/moses/mosesdecoder/scripts/generic/multi-bleu.perl -lc /home/trinhphong/translate_system/expect/expect < /home/trinhphong/Desktop/nmt/run/output_infer > /home/trinhphong/translate_system/expect/bleu.nmt`
    `~/moses/mosesdecoder/scripts/generic/multi-bleu.perl -lc /home/trinhphong/translate_system/expect/expect < /home/trinhphong/moses/run/output_infer > /home/trinhphong/translate_system/expect/bleu.smt`
    redirect_to root_path
  end

  def translate_nmt
    ef = File.open("/home/trinhphong/Desktop/nmt/run/input.en", "w+")
    ef.write params[:src].strip
    ef.close

    system('cd /home/trinhphong/Desktop/nmt && python -m nmt.nmt --out_dir=/home/trinhphong/Desktop/nmt/tuning-output/output-en-vi-full --inference_input_file=/home/trinhphong/Desktop/nmt/run/input.en --inference_output_file=/home/trinhphong/Desktop/nmt/run/output_infer')
  end

  def translate_smt
    `echo #{params[:src].strip} > /home/trinhphong/moses/run/input.en`
    `/home/trinhphong/moses/mosesdecoder/bin/moses -f /home/trinhphong/moses/working-full/fitered-test/moses.ini < /home/trinhphong/moses/run/input.en > /home/trinhphong/moses/run/output_infer`
  end

  def clear
    clear_file
    redirect_to root_path
  end

  private

  def clear_file
    `echo '-' > /home/trinhphong/Desktop/nmt/run/input.en`
    `echo '-' > /home/trinhphong/Desktop/nmt/run/output_infer`
    `echo '-' > /home/trinhphong/moses/run/input.en`
    `echo '-' > /home/trinhphong/moses/run/output_infer`
    `echo '-' > /home/trinhphong/translate_system/expect/expect`
    clear_bleu
  end

  def clear_bleu
    `echo '-' > /home/trinhphong/translate_system/expect/bleu.nmt`
    `echo '-' > /home/trinhphong/translate_system/expect/bleu.smt`
  end
end
