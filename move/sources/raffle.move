module EventRaffle {

    use 0x1::Signer;
    use 0x1::Vector;
    use 0x1::Option;
    use 0x1::Random;

    struct Raffle has copy, drop, store {
        open: bool,
        participants: vector<address>,
        winner: option::address,
    }

    struct RaffleStorage has key {
        admin: address,
        raffle: Raffle,
    }

    fun init_module(admin: &signer) {
        let admin_address = Signer::address_of(admin);
        let raffle = Raffle {
            open: false,
            participants: Vector::empty<address>(),
            winner: Option::none<address>(),
        };
        move_to(admin, RaffleStorage { admin: admin_address, raffle });
    }

    public entry fun open_raffle(account: signer) {
        let raffle_storage = borrow_global_mut<RaffleStorage>(Signer::address_of(&account));
        assert!(Signer::address_of(&account) == raffle_storage.admin, 100, "Not authorized.");
        assert!(!raffle_storage.raffle.open, 101, "Raffle already open.");
        raffle_storage.raffle.open = true;
    }

    public entry fun close_raffle(account: signer) {
        let raffle_storage = borrow_global_mut<RaffleStorage>(Signer::address_of(&account));
        assert!(Signer::address_of(&account) == raffle_storage.admin, 100, "Not authorized.");
        assert!(raffle_storage.raffle.open, 102, "Raffle is not open.");
        raffle_storage.raffle.open = false;
    }

    public entry fun register(account: signer) {
        let user_address = Signer::address_of(&account);
        let raffle_storage = borrow_global_mut<RaffleStorage>(user_address);
        assert!(raffle_storage.raffle.open, 103, "Raffle is not open.");
        assert!(Vector::contains(&raffle_storage.raffle.participants, &user_address) == false, 104, "Already registered.");
        Vector::push_back(&mut raffle_storage.raffle.participants, user_address);
    }

    public entry fun draw_winner(account: signer) {
        let raffle_storage = borrow_global_mut<RaffleStorage>(Signer::address_of(&account));
        assert!(Signer::address_of(&account) == raffle_storage.admin, 100, "Not authorized.");
        assert!(!raffle_storage.raffle.open, 102, "Raffle is still open.");
        assert!(Vector::length(&raffle_storage.raffle.participants) > 0, 105, "No participants.");

        let random_idx = Random::rand_u64() % (Vector::length(&raffle_storage.raffle.participants) as u64);
        let winner = *Vector::borrow(&raffle_storage.raffle.participants, random_idx as u64);
        raffle_storage.raffle.winner = Option::some(winner);
    }

    #[view]
    public fun get_winner(): option::address {
        let raffle_storage = borrow_global<RaffleStorage>(Signer::address_of(&account));
        raffle_storage.raffle.winner
    }

    #[view]
    public fun get_participants(account: address): &vector<address> {
        let raffle_storage = borrow_global<RaffleStorage>(account);
        assert!(account == raffle_storage.admin, 100, "Not authorized.");
        &raffle_storage.raffle.participants
    }

    #[view]
    public fun is_raffle_open(): bool {
        let raffle_storage = borrow_global<RaffleStorage>(Signer::address_of(&account));
        raffle_storage.raffle.open
    }
}
