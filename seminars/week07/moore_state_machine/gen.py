from enum import Enum
from random import randint


class state_machine():
    class State(Enum):
        RESET = 0
        K1 = 1
        K2 = 2
        K3 = 3
        K4 = 4
        UNLOCK = 5

    def __init__(self):
        self.state = state_machine.State.RESET

        self.keys = []
        self.reset = []
        self.outcomes = []
        self.progress = []

    def next_state(self, keys):
        match self.state:
            case state_machine.State.RESET:
                return state_machine.State.K1
            case state_machine.State.K1:
                if keys:
                    # this is better than python ternary
                    return [state_machine.State.K2, state_machine.State.RESET][keys != 1]
                else:
                    return self.state
            case state_machine.State.K2:
                if keys:
                    return [state_machine.State.K3, state_machine.State.RESET][keys != 4]
                else:
                    return self.state
            case state_machine.State.K3:
                if keys:
                    return [state_machine.State.K4, state_machine.State.RESET][keys != 8]
                else:
                    return self.state
            case state_machine.State.K4:
                if keys:
                    return [state_machine.State.UNLOCK, state_machine.State.RESET][keys != 2]
                else:
                    return self.state
            case state_machine.State.UNLOCK:
                return self.state

    def get_progress(self):
        match self.state:
            case state_machine.State.RESET:
                return 0
            case state_machine.State.K1:
                return 0
            case state_machine.State.K2:
                return 1
            case state_machine.State.K3:
                return 2
            case state_machine.State.K4:
                return 4
            case state_machine.State.UNLOCK:
                return 8

    def make_move(self, keys, reset=0):
        self.keys.append(keys)
        self.reset.append(reset)

        if reset:
            self.outcomes.append(0)
            self.progress.append(0)
            self.state = state_machine.State.RESET

            return

        self.state = self.next_state(keys)

        self.outcomes.append(int(self.state == state_machine.State.UNLOCK))
        self.progress.append(self.get_progress())

    def make_reset(self):
        self.make_move(0, 1)

    def make_random_valid_move(self):
        self.make_move(1 << randint(0, 3))

    def make_random_move(self):
        self.make_move(randint(0, 15))

    def get_transitions(self):
        """
        returns iterable of string in a form `xxxx_y_zzzz` where:
            x = bit corresponding to a key
            y = unlock bit
            z = progress bit
        """
        def to_str(value, length):
            return '{0:b}'.format(value).zfill(length)

        def format(keys, outcome, progress, reset):
            return f'{to_str(keys, 4)}_{outcome}_{to_str(progress, 4)}_{reset}'

        return map(lambda x: format(*x),
                   zip(self.keys, self.outcomes, self.progress, self.reset))

    def get_history_size(self):
        return len(self.keys)


def main():
    sm = state_machine()

    # Test correct sequence
    sm.make_move(1)
    sm.make_move(0)
    sm.make_move(4)
    sm.make_move(0)
    sm.make_move(0)
    sm.make_move(8)
    sm.make_move(2)
    sm.make_move(0)

    # Generate random valid sequence
    sm.make_reset()

    for _ in range(148):
        sm.make_random_valid_move()

    # Generate complete random sequence
    sm.make_reset()

    for _ in range(42):
        sm.make_random_move()

    with open('data.b', 'w') as f:
        f.writelines(map(lambda x: x + '\n', sm.get_transitions()))

    print(f'Generated {sm.get_history_size()} test vectors.')


if __name__ == '__main__':
    main()
