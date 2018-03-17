class TranslateCnToViController < ApplicationController
  def index
    @src_nmt = read_src_file "/home/trinhphong/Desktop/nmt/run/input.cn"
    @tgt_nmt = read_tgt_file "/home/trinhphong/Desktop/nmt/run/output_infer_cn_vi"

    @src_smt = read_src_file "/home/trinhphong/moses/run/input.cn"
    @tgt_smt = read_tgt_file "/home/trinhphong/moses/run/output_infer_cn_vi"

    @expect_tgt  = read_src_file "/home/trinhphong/translate_system/expect/expect_cn_vi"

    @bleu_nmt = read_bleu_file "/home/trinhphong/translate_system/expect/bleu.nmt.cn_vi"
    @bleu_smt = read_bleu_file "/home/trinhphong/translate_system/expect/bleu.smt.cn_vi"
  end

  def translate
    translate_nmt
    translate_smt
    clear_bleu
    redirect_to cn_to_vi_path
  end

  def mark
    ef = File.open("/home/trinhphong/translate_system/expect/expect_cn_vi", "w+")
    ef.write params[:expect_tgt]
    ef.close

    `~/moses/mosesdecoder/scripts/generic/multi-bleu.perl -lc /home/trinhphong/translate_system/expect/expect_cn_vi < /home/trinhphong/Desktop/nmt/run/output_infer_cn_vi > /home/trinhphong/translate_system/expect/bleu.nmt.cn_vi`
    `~/moses/mosesdecoder/scripts/generic/multi-bleu.perl -lc /home/trinhphong/translate_system/expect/expect_cn_vi < /home/trinhphong/moses/run/output_infer_cn_vi > /home/trinhphong/translate_system/expect/bleu.smt.cn_vi`
    redirect_to cn_to_vi_path
  end

  def translate_nmt
    ef = File.open("/home/trinhphong/Desktop/nmt/run/input.cn", "w+")
    ef.write params[:src].chars.join(' ').strip
    ef.close

    system('cd /home/trinhphong/Desktop/nmt && python -m nmt.nmt --out_dir=/home/trinhphong/Desktop/nmt/tuning-output/output-cn-vi --inference_input_file=/home/trinhphong/Desktop/nmt/run/input.cn --inference_output_file=/home/trinhphong/Desktop/nmt/run/output_infer_cn_vi')
  end

  def translate_smt
    `echo #{params[:src].chars.join(' ').strip} > /home/trinhphong/moses/run/input.cn`
    `/home/trinhphong/moses/mosesdecoder/bin/moses -f /home/trinhphong/moses/working-cn-vi-no-token/filtered-test/moses.ini < /home/trinhphong/moses/run/input.cn > /home/trinhphong/moses/run/output_infer_cn_vi`
  end

  def clear
    clear_file
    redirect_to cn_to_vi_path
  end

  private

  def clear_file
    `echo '-' > /home/trinhphong/Desktop/nmt/run/input.cn`
    `echo '-' > /home/trinhphong/Desktop/nmt/run/output_infer_cn_vi`
    `echo '-' > /home/trinhphong/moses/run/input.cn`
    `echo '-' > /home/trinhphong/moses/run/output_infer_cn_vi`
    `echo '-' > /home/trinhphong/translate_system/expect/expect_cn_vi`
    clear_bleu
  end

  def clear_bleu
    `echo '-' > /home/trinhphong/translate_system/expect/bleu.nmt.cn_vi`
    `echo '-' > /home/trinhphong/translate_system/expect/bleu.smt.cn_vi`
  end
end
