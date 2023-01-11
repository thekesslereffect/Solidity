pragma solidity ^0.6.0;

contract NumberGame {
  // The current game state
  enum GameState {
    Waiting,
    Playing,
    GameOver
  }
  GameState public state;

  // The user's desired number
  uint public userNumber;

  // The randomly generated number
  uint public randomNumber;

  // Start a new game
  function startGame(uint _userNumber) public {
    // Set the game state to "Playing"
    state = GameState.Playing;

    // Store the user's desired number
    userNumber = _userNumber;

    // Generate a random number with exponentially decreasing odds of the number being high
    randomNumber = generateRandomNumber();
  }

  // Generate a random number
  function generateRandomNumber() private pure returns (uint) {
    // Generate a random number between 1 and 100
    uint number = random();

    // Use an exponentially decreasing function to decrease the odds of the number being high
    uint odds = exp(100 - number);

    // Generate a random number between 1 and the odds
    uint random = random();

    // If the random number is less than or equal to the odds, return the original number
    if (random <= odds) {
      return number;
    }

    // Otherwise, return a low number
    return 1;
  }

  // Check the game result
  function checkResult() public view returns (bool) {
    // Check that the game is in the "Playing" state
    require(state == GameState.Playing, "The game is not currently in progress.");

    // If the user's desired number is less than the random number, the user wins
    return userNumber < randomNumber;
  }
}
