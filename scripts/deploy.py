from brownie import accounts, network, config, TestVipCappedGuestListBbtcUpgradeable


def main():
    deploy()


def deploy():
    account = get_account()
    lottery = TestVipCappedGuestListBbtcUpgradeable.deploy({"from": account})
    return lottery


def get_account(index=None, id=None):

    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENTS
    ):
        return accounts[0]

    return accounts.add(config["wallets"]["from_key"])
