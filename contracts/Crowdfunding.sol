// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding {
    struct Campaign {
        address owner;
        string title;
        string discription;
        uint256 target;
        uint256 deadline;
        string image;
        uint256 amountCollected;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOFCampaign = 0;

    function createCampaign(address _owner, string memory _title, string memory _discription, uint256 _target, uint256 _deadline, string memory _image ) public returns(uint256){
        Campaign storage campaign = campaigns[numberOFCampaign];

        require (campaign.deadline < block.timestamp, "Invalid Deadline");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.discription = _discription;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0 ;
        campaign.image = _image;

        numberOFCampaign++;

        return numberOFCampaign - 1;
    }

    function donateToCampaign (uint256 _id)public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent){
            //to show on frontend how much money is donated to a perticular campaign
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns(address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }
}