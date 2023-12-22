from random import randint


WINDOW_SIZE = 5


def compute(data):
    sum_x = sum([x * w for x, _, w in data])
    sum_y = sum([y * w for _, y, w in data])
    sum_w = sum([w for _, _, w in data])

    # return (round(sum_x / sum_w), round(sum_y / sum_w))
    return (sum_x + sum_w // 2) // sum_w, (sum_y + sum_w // 2) // sum_w


def gen_hard(input):
    def comp(x, y, w, xc, yc):
        return -((x - xc) ** 2 + (y - yc) ** 2), x, y, w

    sub = []
    out = []

    for i in range(len(input)):
        if i < WINDOW_SIZE:
            sub = input[max(0, i - WINDOW_SIZE + 1):i + 1]
        else:
            sub.sort(key=lambda x: comp(*x, *out[-1]))
            sub[0] = input[i]

        out.append(compute(sub))

    return out


def gen_easy(input):
    subs = [input[max(0, i - WINDOW_SIZE + 1):i + 1]
            for i in range(len(input))]

    return [compute(x) for x in subs]


def store(filename, input, output):
    def to_str(value, length):
        return '{0:x}'.format(value).zfill(length)

    def process(xi, yi, wi, xc, yc):
        strings = [
            to_str(xi, 2), to_str(yi, 2), to_str(wi, 1),
            to_str(xc, 2), to_str(yc, 2)
        ]

        return '_'.join(strings)

    processed = [process(*x, *y) for x, y in zip(input, output)]

    with open(filename, 'w') as f:
        f.writelines(map(lambda x: x + '\n', processed))


def main():
    input = [
        (0xff, 0xff, 0x2),
        (0xff, 0xff, 0x5),
        (0x00, 0xff, 0x1),
        (0xff, 0x00, 0xa),
        (0x00, 0x00, 0x7)
    ]

    input += [(randint(0, 0xff), randint(0, 0xff), randint(0, 0xf))
              for _ in range(95)]

    output_easy = gen_easy(input)
    output_hard = gen_hard(input)

    store("data_easy.h", input, output_easy)
    store("data_hard.h", input, output_hard)

    print(f'Generated {len(input)} test vectors.')


if __name__ == '__main__':
    main()
