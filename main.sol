pragma solidity ^0.8.0;

contract Checkmate {
    address public player1;
    address public player2;
    bool public gameFinished;
    mapping(uint => mapping(uint => address)) board;
    
    constructor() {
        player1 = payable(msg.sender);
    }
    
    function joinGame() public {
        require(player2 == address(0), "Game is full!");
        player2 = payable(msg.sender);
    }
    
    function makeMove(uint fromX, uint fromY, uint toX, uint toY) public {
        require(!gameFinished, "Game is over!");
        require(msg.sender == getCurrentPlayer(), "Not your turn!");
        require(fromX < 8 && fromY < 8 && toX < 8 && toY < 8, "Invalid move!");
        address piece = board[fromX][fromY];
        require(piece != address(0), "No piece at source!");
        require(piece == getCurrentPlayer(), "Not your piece!");
        require(isValidMove(piece, fromX, fromY, toX, toY), "Invalid move!");
        board[toX][toY] = piece;
        board[fromX][fromY] = address(0);
        if (isCheckmate(getCurrentPlayer())) {
            gameFinished = true;
            emit GameFinished(getCurrentPlayer());
        }
    }
    
    function getCurrentPlayer() public view returns (address) {
        return board[7][4] == player1 ? player2 : player1;
    }
    
    function isValidMove(address piece, uint fromX, uint fromY, uint toX, uint toY) internal view returns (bool) {
        bool valid = false;
        // Check if move is valid
        if (piece == player1) {
            valid = (toX == 6 && toY == 5) || (toX == 6 && toY == 1);
        } else {
            valid = (toX == 1 && toY == 5) || (toX == 1 && toY == 1);
        }
        return valid;
    }

    function isCheckmate(address player) internal view returns (bool) {
        // Check if player is in checkmate (only applicable to this simplified chess example)
        bool checkmate = false;
        if (player == player1) {
            checkmate = board[7][4] != player1; // King is taken
        } else {
            checkmate = board[0][4] != player2; // King is taken
        }
        return checkmate;
    }
    
    event GameFinished(address winner);
    // Other game-related functions (e.g. forfeit, draw) could be included here
}
