# SPDX-License-Identifier: Apache-2.0
# OpenZeppelin Contracts for Cairo v0.1.0 (tournament/RankedSeason.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import (TRUE, FALSE)
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

# OpenZeppeling dependencies
from openzeppelin.access.ownable import (Ownable_initializer, Ownable_only_owner)
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20

# ------------
# STORAGE VARS
# ------------

@storage_var
func season_id_() -> (res : felt):
end

@storage_var
func season_name_() -> (res : felt):
end

@storage_var
func reward_token_address_() -> (res : felt):
end

@storage_var
func is_season_open_() -> (res : felt):
end

# -----
# VIEWS
# -----
@view
func season_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (season_id : felt):
    let (season_id) = season_id_.read()
    return (season_id)
end

@view
func season_name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (season_name : felt):
    let (season_name) = season_name_.read()
    return (season_name)
end

@view
func reward_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (season_id : felt):
    let (reward_token_address) = reward_token_address_.read()
    return (reward_token_address)
end

@view
func is_season_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (is_season_open : felt):
    let (is_season_open) = is_season_open_.read()
    return (is_season_open)
end

@view
func reward_total_amount{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (reward_total_amount : Uint256):
    let (reward_token_address) = reward_token_address_.read()
    let (contract_address) = get_contract_address()
    let (reward_total_amount) = IERC20.balanceOf(
        contract_address=reward_token_address, account=contract_address
    )
    return (reward_total_amount)
end

# -----
# CONSTRUCTOR
# -----

@constructor
func constructor{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        owner: felt,
        season_id: felt,
        season_name: felt,
        reward_token_address: felt
    ):
    Ownable_initializer(owner)
    season_id_.write(season_id)
    season_name_.write(season_name)
    reward_token_address_.write(reward_token_address)
    return ()
end

# -----
# EXTERNAL FUNCTIONS
# -----

@external
func open_season{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (success: felt):
    Ownable_only_owner()
    _only_season_closed()
    return (TRUE)
end

@external
func close_season{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (success: felt):
    Ownable_only_owner()
    _only_season_open()
    return (TRUE)
end

# -----
# INTERNAL FUNCTIONS
# -----

func _only_season_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
):
    let (is_season_open) = is_season_open_.read()
    with_attr error_message("RankedSeaon: season is open"):
        is_season_open = TRUE
    end
    return ()
end

func _only_season_closed{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
):
    let (is_season_open) = is_season_open_.read()
    with_attr error_message("RankedSeaon: season is closed"):
        is_season_open = FALSE
    end
    return ()
end