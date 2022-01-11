# Tic Tac Toe 보드 라인 디자인
def board(tictactoe, dimension):
    for i in range(dimension):
        print(' _', end = '')
    for i in range(dimension):
        print()
        print('|', end = '')
        for j in range(dimension):
            print(tictactoe[i][j] + '|', end = '')
    print()

# Tik Tac Toe 게임 보드의 크기 지정(최소 사이즈 3x3)
# 알맞은 dimension 입력할 때까지 반복
while True:
    dimension = int(input("Tik Tac Toe 보드 크기를 정해주세요 (최소 크기 : 3 x 3): "))
    if dimension <= 2 :
        print('[Error] 최소 크기 미만의 수를 입력하셨습니다. 다시 입력해주세요.')
    else:
        break

tictactoe = [['_']*dimension for i in range(dimension)]
board(tictactoe, dimension)

turn = 1
# 플레이 횟수를 나타내는 변수 play_count 생성
play_count = 0
while True:
    print('<Play no.{}>'.format(play_count+1))
    if turn == 1:
        print('현재 Player: 1')
        row_1 = int(input('행 선택?(start with 1)'))
        column_1 = int(input('열 선택?(start with 1)'))

        if tictactoe[row_1-1][column_1-1] != '_':
            print('이미 입력된 행렬입니다. 다시 입력해주세요.')
            turn = 1
            continue
        else:
            tictactoe[row_1-1][column_1-1] = 'O'
            board(tictactoe,dimension)
            turn = 2

    elif turn == 2:
        print('현재 player: 2')
        row_2 = int(input('행 선택?(start with 1) '))
        column_2 = int(input('열 선택?(start with 1) '))

        if tictactoe[row_2-1][column_2-1] != '_':
            print('이미 입력된 행렬입니다. 다시 입력해주세요.')
            turn = 2
            continue
        else:
            tictactoe[row_2-1][column_2-1] = 'X'
            board(tictactoe,dimension)
            turn = 1

    check_diag = []
    check_reverse = []
    check_row = []
    check_column =[]
            
    for i in range(dimension):
        check_diag.append(tictactoe[i][i])
        check_reverse.append(tictactoe[dimension-i-1][i])
        
        # row, column에 의한 결과는 이중for문으로 확인
        # 두 번째 for문을 통해 괄과 여부를 확인하고
        for j in range(dimension):
            check_row.append(tictactoe[i][j])
            check_column.append(tictactoe[j][i])
        
        if set(check_row) == {'O'}:
            print('Player 1 이 승리했습니다!')
            turn = 0
        elif set(check_row) == {'X'}:
            print('Player 2 이 승리했습니다!')
            turn = 0
        # 두 번째 for문이 끝나면 check_row를 초기화를 시켜주어야합니다.
        check_row = []

        if set(check_column) == {'O'}:
            print('Player 1 이 승리했습니다!')
            turn = 0
        elif set(check_column) == {'X'}:
            print('Player 2 이 승리했습니다!')
            turn = 0
        # 마찬가지로 두 번째 for문이 끝나면 check_column 초기화
        check_column = []

    check_diag = set(check_diag)
    check_reverse = set(check_reverse)

    if check_diag == {'O'} or check_reverse == {'O'}:
        print('Player 1 이 승리했습니다!')
        turn = 0
        
    elif check_diag == {'X'} or check_reverse == {'X'}:
        print('Player 2 이 승리했습니다!')
        turn = 0

    # 누군가의 플레이가 끝나면 1씩 증가합니다.
    play_count += 1

    # 위의 코드를 보시면 승자가 나타날 경우 turn은 0이 됩니다.
    # turn이 0이 되었거나 플레이 횟수가 dimension의 제곱값이 되면
    # 경기를 종료합니다.
    if turn == 0 or play_count == dimension**2:
        print('Finish')
        break

