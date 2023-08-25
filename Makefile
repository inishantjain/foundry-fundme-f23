-include .env 

build:; forge build
deploy-spolia:
	forge script script/DeployFundMe.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)  -vvvv