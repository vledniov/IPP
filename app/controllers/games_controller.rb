class GamesController < ApplicationController
  def index
    @player = params[:player].nil? ? "Player1" : params[:player]
  end

  def results
    @score1 = params[:score1]
    @score2 = params[:score2]
  end

  def score
    if params[:next_player] == "Player2"
      Mediators::Game.new(params[:score])
      render :js => "window.location = '/games?player=#{params[:next_player]}'"
    elsif params[:next_player] == "Scoreboard"
      scores = Mediators::Game.new(nil, params[:score]).get_scores
      render :js => "window.location = '/games/results?#{scores}'"
    end
  end
end
