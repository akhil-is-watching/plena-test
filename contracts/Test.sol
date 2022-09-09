// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface IComet {
    function supply(address asset, uint amount) external;
}

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

}


interface IERC20 {

    function balanceOf(address account) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);   

}

contract TestSwapLend {

    // comet address for usdt
    address public cometAddress;
    address public routerAddress;

    address public usdtAddress;
    address public usdcAddress;

    constructor(address _comet, address _router, address _usdt, address _usdc) {
        cometAddress = _comet;
        routerAddress = _router;
        usdtAddress = _usdt;
        usdcAddress = _usdc;
    }

    function complete() public {

        // SWAP
        uint256 usdcBalance = IERC20(usdcAddress).balanceOf(address(this));
        IERC20(usdcAddress).approve(routerAddress, usdcBalance);

        _swapUSDC(usdcBalance, usdcAddress, usdtAddress);

        // LEND
        uint256 usdtBalance = IERC20(usdtAddress).balanceOf(address(this));
        IERC20(usdtAddress).approve(cometAddress, usdtBalance);

        IComet(cometAddress).supply(usdtAddress, usdtBalance);

    }

    function _swapUSDC(uint256 _amount, address _usdc, address _usdt) internal {
        address[] memory path = new address[](2);
        path[0] = _usdc;
        path[1] = _usdt;
        uint256[] memory amountOut = IUniswapV2Router(routerAddress).getAmountsOut(_amount, path);
        IUniswapV2Router(routerAddress).swapExactTokensForTokens(_amount, amountOut[1], path, address(this), block.timestamp + 15);
    }
}