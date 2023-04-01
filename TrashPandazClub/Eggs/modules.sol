contract gen3_Controller{
    // controlls minting of gen3 Token contract as well as anything 
    // else related to updating the token so we can upgrade later
    // make this pausable so users can't accidentally use an old controller
}

contract gen3_Token is ERC1155{
    // This is hard data. Only include things you dont want to change in the future
    // mint token id to owner
    // token id => random seed
    // token id => birthday
    // token id => owner
    // token id => hatched
    // token id => rare/legendary
    // token id => colors[]
    // create metadata from other contacts
}

contract gen3_Image{
    // recieves info from token id and converts to image string
    // test an image generation loop instead of hardcode svg
    // check hatched to update from egg to character
}

contract gen3_Attributes{
    // recieves info from token id and converts to attribute string
    // future versions will include a level contract
}

contract gen3_LevelSystem{
    // increase level stats
}
