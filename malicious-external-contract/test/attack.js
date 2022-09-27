const {expect} = require("chai");
const {BigNumber} = require("ethers");
const {ethers, waffle} = require("hardhat");

describe("Attack", function () {
    it("Should change the owner of the Good contract", async function () {
        // Deploy the Attack contract
        const attackContract = await ethers.getContractFactory("Attack");
        const _attackContract = await attackContract.deploy();
        await _attackContract.deployed();
        console.log("Attack Contract's Address", _attackContract.address);

        // Deploy the good contract
        const goodContract = await ethers.getContractFactory("Good");
        const _goodContract = await goodContract.deploy(_attackContract.address, {
            value: ethers.utils.parseEther("3"),
        });
        await _goodContract.deployed();
        console.log("Good Contract's Address:", _goodContract.address);

        const [_, addr1] = await ethers.getSigners();
        // Now lets add an address to the eligibility list
        let tx = await _goodContract.connect(addr1).addUserToList();
        await tx.wait();

        // check if the user is eligible
        const eligible = await _goodContract.connect(addr1).isUserEligible();
        expect(eligible).to.equal(false);
    });
});