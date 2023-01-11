// SPDX-License-Identifier: MIT LICENSE
pragma solidity 0.8.7;
contract SortArray{

    uint[] arr = [5,1,3,2,8,7];
    
    function bubbleSortPermanent() public returns(uint[] memory){
        uint length = arr.length;
        for (uint i=0; i<length-1; i++){
            for (uint j=0; j<length-1; j++){
                if(arr[j]<arr[j+1]){ // arr[j]>arr[j+1] if you want ascending
                    uint current_value = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = current_value;
                }
            }
        }
        return arr;
    }

    function bubbleSortTemporary() public view returns(uint[] memory){
        uint[] memory _arr = arr;
        uint length = _arr.length;
        for (uint i=0; i<length-1; i++){
            for (uint j=0; j<length-1; j++){
                if(_arr[j]<_arr[j+1]){ // _arr[j]>_arr[j+1] if you want ascending
                    uint current_value = _arr[j];
                    _arr[j] = _arr[j+1];
                    _arr[j+1] = current_value;
                }
            }
        }
        return _arr;
    }

    function viewArr() public view returns(uint[] memory){
        return arr;
    }










    // Leaderboard
    struct Leaderboard {
        bool entered;
        uint256 claimed;
        uint256 multiplier;
    }
    mapping(address => Leaderboard ) public leaderboard;
    mapping(uint => address) public leaderboardIndex;
    uint public totalInLeaderboardIndex;

    struct LeaderboardDisplay {
        address[] addresses;
        uint256[] values;
    }
    LeaderboardDisplay[] leaderboardDisplay;


    function updateLeaderboard(address _account, uint256 _claimAmount, uint256 _multiplierAmount) public {
        Leaderboard memory _leaderboard = leaderboard[_account];
        if(_leaderboard.entered == false){
            leaderboardIndex[totalInLeaderboardIndex] = _account;
            totalInLeaderboardIndex++;
        }
        bool _entered = true;
        uint256 _claimed = _leaderboard.claimed + _claimAmount;
        leaderboard[_account] = Leaderboard({
            entered: _entered,
            claimed: _claimed,
            multiplier: _multiplierAmount
        });
    }

    function getClaimedLeaderboard() public view returns(address[] memory, uint[] memory){
        address[] memory _addressArray = new address[](totalInLeaderboardIndex);
        uint[] memory _claimedArray = new uint[](totalInLeaderboardIndex);
        address _account;
        for(uint i=0; i<totalInLeaderboardIndex; i++){
            _account = leaderboardIndex[i];   
            _addressArray[i] = _account;
            _claimedArray[i] = leaderboard[_account].claimed;
        }
        return sortArrayDecending(_addressArray, _claimedArray);
    }

    function getMultiplierLeaderboard() public view returns(address[] memory, uint[] memory){
        address[] memory _addressArray = new address[](totalInLeaderboardIndex);
        uint[] memory _multiplierArray = new uint[](totalInLeaderboardIndex);
        address _account;
        for(uint i=0; i<totalInLeaderboardIndex; i++){
            _account = leaderboardIndex[i];           
            _addressArray[i] = _account;
            _multiplierArray[i] = leaderboard[_account].multiplier;
        }
        return sortArrayDecending(_addressArray, _multiplierArray);
    }

    function getLeaderboard() public view returns(LeaderboardDisplay memory, LeaderboardDisplay memory){
        address[] memory _addressArray = new address[](totalInLeaderboardIndex);
        uint[] memory _claimedArray = new uint[](totalInLeaderboardIndex);
        uint[] memory _multiplierArray = new uint[](totalInLeaderboardIndex);
        address _account;
        for(uint i=0; i<totalInLeaderboardIndex; i++){
            _account = leaderboardIndex[i];    
            _addressArray[i] = _account;
            _claimedArray[i] = leaderboard[_account].claimed;
            _multiplierArray[i] = leaderboard[_account].multiplier;
        }

        LeaderboardDisplay memory leaderboardDisplayClaimed;
        LeaderboardDisplay memory leaderboardDisplayMultipliers;
        (leaderboardDisplayClaimed.addresses, leaderboardDisplayClaimed.values) = sortArrayDecending(_addressArray, _claimedArray);
        (leaderboardDisplayMultipliers.addresses, leaderboardDisplayMultipliers.values) = sortArrayDecending(_addressArray, _multiplierArray);
        return (leaderboardDisplayClaimed,leaderboardDisplayMultipliers);
    }

    function sortArrayDecending(address[] memory _address, uint[] memory _array) public pure returns(address[] memory, uint[] memory){
        uint[] memory _arr = _array;
        address[] memory _addr = _address;
        uint length = _arr.length;
        for (uint i=0; i<length-1; i++){
            for (uint j=0; j<length-1; j++){
                if(_arr[j]<_arr[j+1]){ // _arr[j]>_arr[j+1] if you want ascending
                    uint current_value = _arr[j];
                    _arr[j] = _arr[j+1];
                    _arr[j+1] = current_value;

                    address current_addr = _addr[j];
                    _addr[j] = _addr[j+1];
                    _addr[j+1] = current_addr;
                }
            }
        }
        return (_addr, _arr);
    }










}