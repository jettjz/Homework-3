pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */

	function BadAuction() {
		highestBid = 0;
		highestBidder = msg.sender;
	}

	function bid() payable external returns (bool) {
		if (msg.value <= highestBid) {
			msg.sender.transfer(msg.value);
			return false;
		}
		if (highestBid != 0) {
			if (!highestBidder.send(highestBid)) {
				msg.sender.transfer(msg.value);
				return false;
			}
		}
		highestBidder = msg.sender;
		highestBid = msg.value;
		return true;
	}

	/* Give people their funds back */
	function () payable {
		revert();
	}
}
