require_relative '../lib/captains_mistress/app'

describe "Game" do
  let(:game) { CaptainsMistress::App.new }

  describe "#check_board_for_winner?" do
    it "returns false with no valid segment of 4" do
      game.board[0].push(1)
      expect(game.check_board_for_winner?(0)).to eq(false)
    end

    it "returns true with a valid vertical segment of 4" do
      4.times { game.board[0].push(1) }
      expect(game.check_board_for_winner?(0)).to eq(true)
    end

    it "returns true with a valid horizontal segment of 4" do
      4.times { |i| game.board[i].push(1) }
      expect(game.check_board_for_winner?(0)).to eq(true)
    end

    it "returns true with a valid diagonal segment of 4" do
      diag_idx = 0
      4.times do |i|
        game.board[i][diag_idx] = 1
        diag_idx += 1
      end
      expect(game.check_board_for_winner?(0)).to eq(true)
    end
  end
end
