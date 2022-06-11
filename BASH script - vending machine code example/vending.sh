#! /bin/bash

# vending.sh 
# Date : 2022-06-02
# Author : 소프트웨어공학과, 학번 21911200, 김영환
#
# 스크립트 기능 설명 
# 1. 스크립트 실행 시 자판기 메뉴 표시 ( with 실행 날짜와 횟수도 표시 )
# 2. 자판기에 금액 입력 ( 화폐별 수량 입력 후 충 입금액 표시 )
# 3. 자판기에서 구입할 물건 선택 ( 물건가격이 삽입 금액보다 크면 결제 되지 않고 초기 메뉴 화면으로 돌아감 )
# 4. 자판기에서 정상적으로 물건 구입 시 사용자가 삽입한 금액은 자판기의 거스름돈 수량으로 포함되며 사용자에게 거스름돈을 주는 로직 구현
# 5. 거스름돈 정산 후 자판기 거스름돈 수량에서 차감 ( 거스름돈이 모자라면 메세지 출력 )
# 6. 자판기에서 물품 구매 프로세스 정상적으로 완료되면 메뉴 화면으로 루프 구현이 되면서 거스름돈 수량은 계속 변동 누적이 가능함.

# 사용되는 변수 정수형 선언
declare -i insertMoney
declare -i result
declare -i menuNumber

# 자판기 제품 상수 선언
declare -r priceCola=850
declare -r priceCydar=800
declare -r priceFanta=750
declare -r priceWater=500

# 삽입되는 금액별 수량 선언
declare -i insertMoneyA # 1,000원권
declare -i insertMoneyB #   500원권
declare -i insertMoneyC #   100원권
declare -i insertMoneyD #    50원권
declare -i insertMoneyE #    10원권

# 자판기가 보유한 거스름돈 수량, 프로그램이 실행되면서 수량은 계속 변동이 발생된다.
declare -i changeStock1=5   # 1,000원권 수량
declare -i changeStock2=10  #   500원권 수량
declare -i changeStock3=10  #   100원권 수량
declare -i changeStock4=10  #    50원권 수량
declare -i changeStock5=30  #    10원권 수량

#실행 카운터 : 몇번 프로그램 루프가 도는지 카운터로 확인
declare -i count=1

# 자판기에 제품 결제를 위해 돈을 추가 및 정상적으로 입력이 잘 되었는지 확인하는 함수
function InsertMoney(){
    read -p "   1000원권 추가 개수  : " insertMoneyA
    read -p "    500원권 추가 개수  : " insertMoneyB
    read -p "    100원권 추가 개수  : " insertMoneyC
    read -p "     50원권 추가 개수  : " insertMoneyD
    read -p "     10원권 추가 개수  : " insertMoneyE

    if [ ${insertMoneyA} -ge 0 -a ${insertMoneyB} -ge 0 -a ${insertMoneyC} -ge 0 -a ${insertMoneyD} -ge 0 -a ${insertMoneyE} -ge 0 ];
    then
        let InsertTotalMoney=$(($insertMoneyA*1000))+$(($insertMoneyB*500))+$(($insertMoneyC*100))+$(($insertMoneyD*50))+$(($insertMoneyE*10))
        echo -e "   총 삽입된 금액은 $InsertTotalMoney 원 입니다\n"
    else
        echo -e "\n   정상적인 수량을 입력해주세요. (숫자Only)\n"
        exit
    fi
}

# 제품 결제에 대한 함수
function Calculate(){
    # 결제후 잔액값을 함수 호출시 마다 초기화
    result=0
    let result=$1-$2  
    # 결제 결과에 따라 메세지 출력
    if [ ${result} -ge 0 ]
    then
        # 정상적인 결제일 때 삽입된 금액 수량을 자판기의 거스름돈 수량에 반영 후 사용자에게 줄 거스름돈 금액을 표기.
        let changeStock1+=$(($insertMoneyA))
        let changeStock2+=$(($insertMoneyB))
        let changeStock3+=$(($insertMoneyC))
        let changeStock4+=$(($insertMoneyD))
        let changeStock5+=$(($insertMoneyE))
        echo -e "\n   거스름돈은 $[ $result ] 원입니다.\n"
    else
        echo -e "\n   금액이 부족합니다. 부족한 금액은 $[ $result ] 원입니다. 메뉴로 돌아갑니다.\n"
        read -s -n1 -p "   아무키나 누르세요..." keypress
    fi
}

# 거스름돈에 대한 함수 : 거스름돈 수량에 추가 및 사용 등
function ChangeMoney(){
    local let change_A=$(($result/1000))
    local let changeB=$(($result%1000))
    local let change_B=$(($changeB/500))
    local let changeC=$(($result%500))
    local let change_C=$(($changeC/100))
    local let changeD=$(($result%100))
    local let change_D=$(($changeD/50))
    local let changeE=$(($result%50))
    local let change_E=$(($changeE/10))

    if [ ${change_A} -gt 0 ]; then
        echo "   1,000원 거스름돈은 $change_A 장입니다"
        let changeStock1-=$(($change_A))
    fi
    if [ ${change_B} -gt 0 ]; then
        echo "     500원 거스름돈은 $change_B 개입니다"
        let changeStock2-=$(($change_B))
    fi
    if [ ${change_C} -gt 0 ]; then
        echo "     100원 거스름돈은 $change_C 개입니다"
        let changeStock3-=$(($change_C))
    fi
    if [ ${change_D} -gt 0 ]; then
        echo "      50원 거스름돈은 $change_D 개입니다"
        let changeStock4-=$(($change_D))
    fi
    if [ ${change_E} -gt 0 ]; then
        echo -e "      10원 거스름돈은 $change_E 개입니다"
        let changeStock5-=$(($change_E))
    fi

    echo ""
    read -p "   현재 자판기의 거스름돈 수량을 확인하고 싶으십니까? (Y/N) : " Answer

    if [ ${Answer} == Y -o ${Answer} == y ]; then
        echo "   1,000원 거스름돈은 $changeStock1 장입니다"
        echo "     500원 거스름돈은 $changeStock2 개입니다"
        echo "     100원 거스름돈은 $changeStock3 개입니다"
        echo "      50원 거스름돈은 $changeStock4 개입니다"
        echo "      10원 거스름돈은 $changeStock5 개입니다"
    else
        echo "   언제든지 필요하면 거스름돈 수량을 확인 하실 수 있습니다"
    fi
    echo ""
    read -s -n1 -p "   아무키나 누르세요..." keypress
}

# 자판기가 가지고 있는 거스름돈 수량이 부족해서 결제가 안될 때 이유를 보여주는 함수
function MachineChange(){
    if [ ${changeStock1} -lt 0 -o ${changeStock2} -lt 0 -o ${changeStock3} -lt 0 -o ${changeStock4} -lt 0 -o ${changeStock5} -lt 0 ]
    then
    echo -e "\n\n   자판기가 보유한 거스름돈 수량 중 일부가 부족해서 결제할 수 없습니다"
    echo "   최종 자판기의 1000원권 수량은 $changeStock1 장 입니다"
    echo "   현재 자판기의  500원권 수량은 $changeStock2 개 입니다"
    echo "   현재 자판기의  100원권 수량은 $changeStock3 개 입니다"
    echo "   현재 자판기의   50원권 수량은 $changeStock4 개 입니다"
    echo "   현재 자판기의   10원권 수량은 $changeStock5 개 입니다"
    echo "   프로그램을 종료합니다"
    exit
    fi    
}

while :
do
    # 스크립트 실행시 메뉴 출력
    clear
    echo "   실행 횟수 : $count 번째 실행 중"
    let count+=1
    echo "   실행 시간 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"
    echo -e "========== 자판기 메뉴 =========="
    echo "    메뉴 1  :  콜라    850원"
    echo "    메뉴 2  :  사이다  800원"
    echo "    메뉴 3  :  환타    750원"
    echo "    메뉴 4  :  생수    500원"
    echo -e "================================\n"
    InsertMoney
    read -p "   메뉴를 선택해주세요 : " menuNumber

    # 입력된 메뉴의 값이 메뉴 항목에 있는지 확인 OR 로 확인함.
    if [ ${menuNumber} -eq 1 -o ${menuNumber} -eq 2 -o ${menuNumber} -eq 3 -o ${menuNumber} -eq 4 ]
        then

    # 선택한 메뉴에 대해 입력한 금액과 비교 후 처리되는 부분
        if [ ${menuNumber} -eq 1 ]
            then
            if [ ${InsertTotalMoney} -ge ${priceCola} ]
            then
                # 함수 호출 부분 : 계산 부분과 거스름돈 출력 부분 함수 각각 호출
                Calculate $InsertTotalMoney $priceCola
                ChangeMoney
                # 만약에 자판기에 있는 거스름돈 수량이 부족한 경우에는 어떤 화폐 수량이 부족한지 메세지로 표출 후 프로그램 종료
                MachineChange
            elif [ ${InsertTotalMoney} -lt ${priceCola} ]
            then
                Calculate $InsertTotalMoney $priceCola
            fi
        elif [ ${menuNumber} -eq 2 ]
            then
            if [ ${InsertTotalMoney} -ge ${priceCydar} ]
            then
                Calculate $InsertTotalMoney $priceCydar
                ChangeMoney
                MachineChange
            elif [ ${InsertTotalMoney} -lt ${priceCydar} ]
            then
                Calculate $InsertTotalMoney $priceCydar
            fi
        elif [ ${menuNumber} -eq 3 ]
            then
            if [ ${InsertTotalMoney} -ge ${priceFanta} ]
            then
                Calculate $InsertTotalMoney $priceFanta
                ChangeMoney
                MachineChange
            elif [ ${InsertTotalMoney} -lt ${priceFanta} ]
            then
                Calculate $InsertTotalMoney $priceFanta
            fi
        elif [ ${menuNumber} -eq 4 ]
            then
            if [ ${InsertTotalMoney} -ge ${priceWater} ]
            then
                Calculate $InsertTotalMoney $priceWater
                ChangeMoney
                MachineChange
            elif [ ${InsertTotalMoney} -lt ${priceWater} ]
            then
                Calculate $InsertTotalMoney $priceWater
            fi
        fi
        # 메뉴 선택시 잘못된 메뉴 번호 입력시 출력 메세지
        else
            echo -e "\n   선택한 메뉴는 상품이 없습니다. 자판기 거스름돈 최종 수량입니다.\n"
            echo "   자판기의 1000원권 최종 수량은 $changeStock1 장 입니다"
            echo "   자판기의  500원권 최종 수량은 $changeStock2 개 입니다"
            echo "   자판기의  100원권 최종 수량은 $changeStock3 개 입니다"
            echo "   자판기의   50원권 최종 수량은 $changeStock4 개 입니다"
            echo "   자판기의   10원권 최종 수량은 $changeStock5 개 입니다"
            echo "   프로그램을 종료합니다."
            break
    fi
done