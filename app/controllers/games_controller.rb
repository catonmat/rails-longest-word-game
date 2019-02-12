require 'open-uri'

class GamesController < ApplicationController
  def new
    @letter_array = ('a'..'z').to_a
    @letter_choice = 8.times.map{ @letter_array[rand(0..25)] }
  end

  def score
    @messages = {
      array_fail: "Sorry, #{params[:answer]} cannot be generated from #{params[:letter_choice]}",
      dictionary_fail: "Sorry, #{params[:answer]} does not seem to be a valid English word.",
      success: "Well done! #{params[:answer]} is an English word!"
    }
    @total_score = 0
    @results_display = display_message
    @total_score = calculate_score if @results_display == @messages[:success]
  end

  private

  def display_message
    return @messages[:array_fail] unless check_word_against_array
    return @messages[:dictionary_fail] unless check_word_against_dictionary

    @messages[:success]
  end

  def check_word_against_array
    answer = params[:answer].split("").sort
    letter_choice = params[:letter_choice].split("").sort

    answer_hash = Hash.new(0)
    choice_hash = Hash.new(0)
    answer.each { |letter| answer_hash[letter] = answer.count(letter) }
    letter_choice.each { |letter| choice_hash[letter] = letter_choice.count(letter) }

    confirmation = answer_hash.select { |key| answer_hash[key] == choice_hash[key] }
    return true if confirmation.size == answer_hash.size
  end

  def check_word_against_dictionary
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    doc = URI.open(url).read
    api_call = JSON.parse(doc)
    api_call["found"]
  end

  def calculate_score
    score = params[:answer].length
    start_time = params[:start_time].to_time
    total_time = DateTime.now.to_time - start_time
    final_score = score*1000 / total_time
    final_score.round
  end
end
