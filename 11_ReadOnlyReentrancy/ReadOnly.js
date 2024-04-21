const { time, loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "ReadOnlyPool";

describe(NAME, function () {
    async function setup() {
        const [deployer, attackerWallet] = await ethers.getSigners();

        const ReadOnlyFactory = await ethers.getContractFactory(NAME);
        const readOnlyContract = await ReadOnlyFactory.deploy();

        const VulnerableDeFiFactory = await ethers.getContractFactory("VulnerableDeFiContract");
        const vulnerableDeFiContract = await VulnerableDeFiFactory.deploy(readOnlyContract.address);

        const attackerFactory = await ethers.getContractFactory("ReadOnlyAttacker");
        const attackContract = await attackerFactory.deploy(vulnerableDeFiContract.address, readOnlyContract.address);

        await readOnlyContract.addLiquidity({
            value: ethers.utils.parseEther("100"),
        });
        await readOnlyContract.earnProfit({ value: ethers.utils.parseEther("1") });
        await vulnerableDeFiContract.snapshotPrice();

        // you start with 2 ETH
        await network.provider.send("hardhat_setBalance", [
            attackerWallet.address,
            ethers.utils.parseEther("2.0").toHexString(),
        ]);

        return {
            readOnlyContract,
            vulnerableDeFiContract,
            attackContract,
            attackerWallet,
            deployer,
        };
    }

    describe("exploit", async function () {
        let readOnlyContract, vulnerableDeFiContract, attackContract, attackerWallet, deployer;
        before(async function () {
            ({ readOnlyContract, vulnerableDeFiContract, attackContract, attackerWallet, deployer } = await loadFixture(
                setup
            ));
        });

        // prettier-ignore
        it("conduct your attack here", async function () {
            // 1. addliquidity
            // 2. removeLiquidity but call snapshot() on eth received
            await attackContract.connect(attackerWallet).attack({value: ethers.utils.parseEther("1")});
        });

        after(async function () {
            expect(await vulnerableDeFiContract.lpTokenPrice()).to.be.equal(0, "snapshotPrice should be zero");
            expect(await ethers.provider.getTransactionCount(attackerWallet.address)).to.lessThan(
                3,
                "must exploit two transactions or less"
            );
        });
    });
});
