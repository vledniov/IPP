class Mediators::Game
  cattr_reader :player1_score, :player2_score

  def initialize(score1=nil, score2=nil)
    @@player1_score = score1.nil? ? @@player1_score : score1
    @@player2_score = score2.nil? ? @@player1_score : score2
  end

  def get_scores
    "score1=#{@@player1_score}&score2=#{@@player2_score}"
  end
end
