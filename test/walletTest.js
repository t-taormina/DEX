const Dex = artifacts.require("Dex");
const Link = artifacts.require("Link");
const truffleAssert = require("truffle-assertions");


contract("Dex", accounts => {
    it("Should only be possible for owner to add tokens", async() => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()
        await truffleAssert.passes(
            dex.addToken(web3.utils.fromUtf8("LINK"), link.address, {from: accounts[0]})
        )
        await truffleAssert.reverts(
            dex.addToken(web3.utils.fromUtf8("LINK"), link.address, {from: accounts[1]})
        )
    })

    it("Should handle deposits correctly", async() => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()
        await link.approve(dex.address, 500)
        await dex.deposit(100, web3.utils.fromUtf8("LINK"))
        let balance = await dex.balances(accounts[0], web3.utils.fromUtf8("LINK"))
        assert.equal(balance.toNumber(), 100)
    })

    it("Should handle withdraws correctly", async() => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()
        await dex.withdraw(40, web3.utils.fromUtf8("LINK"))
        //Withdraw 40 from balance. Balance was 100 so we are checking that new balance = 100 - 40 = 60
        let balance = await dex.balances(accounts[0], web3.utils.fromUtf8("LINK"))
        assert.equal(balance.toNumber(), 60)
    })

    it("Should handle overdrawn withdraws correctly.", async() => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()
        //Withdraw over balance. Should revert.
        await truffleAssert.reverts(dex.withdraw(200, web3.utils.fromUtf8("LINK")))
    }) 

})
