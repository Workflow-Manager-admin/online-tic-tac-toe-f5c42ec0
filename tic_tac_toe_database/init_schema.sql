-- Tic Tac Toe Application Database Schema Initialization (MySQL)
-- This script creates users, games, and moves tables with appropriate relationships

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table: games
CREATE TABLE IF NOT EXISTS games (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_x_id INT NOT NULL,
    player_o_id INT NOT NULL,
    state VARCHAR(32) NOT NULL DEFAULT 'in_progress',
    winner INT DEFAULT NULL, -- nullable, stores user id of winner if game is finished
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_player_x FOREIGN KEY (player_x_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_player_o FOREIGN KEY (player_o_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_winner FOREIGN KEY (winner) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Table: moves
CREATE TABLE IF NOT EXISTS moves (
    id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    player_id INT NOT NULL,
    move_index TINYINT NOT NULL, -- 0-8 board position (top-left to bottom-right)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_game FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    CONSTRAINT fk_player FOREIGN KEY (player_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_game_move (game_id, move_index) -- prevents duplicate move on the same spot
) ENGINE=InnoDB;

-- Index for fast retrieval of moves in a game by order
CREATE INDEX idx_game_moves ON moves(game_id, id);

-- State values: 'in_progress', 'draw', 'finished'
-- Note: Username uniqueness enforced. 
-- Moves table holds the move history (player_id, game_id, move index in order).
