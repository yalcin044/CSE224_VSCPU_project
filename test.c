// CORRESPONDING C PROGRAM TO TEST GIVEN ASSEMBLY PROGRAM


#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

uint32_t mem[256];

int main() {
    // INITIALIZATION
    mem[100] = 5;
    mem[101] = 8;
    mem[102] = 16;
    mem[103] = 4294967295; 
    mem[108] = 65543;
    mem[111] = 1;
    mem[113] = 35;
    mem[114] = 120;
    
    int PC = 0;
    bool running = true;
    uint32_t res; // Temporary result variable

    while (running) {
        if (PC > 255) break;

        switch (PC) {
            case 0: // CPi 110 3
                printf("PC:%d | CPi 110 3 | Before: Imm=3 -> After: mem[110]=3\n", PC);
                mem[110] = 3;
                PC++; 
                break;

            case 1: // ADD 100 101
                res = mem[100] + mem[101];
                printf("PC:%d | ADD 100 101 | Before: mem[100]=%u, mem[101]=%u -> After: mem[100]=%u, mem[101]=%u\n", 
                       PC, mem[100], mem[101], res, mem[101]);
                mem[100] = res;
                PC++;
                break;

            case 2: // MUL 100 102
                res = mem[100] * mem[102];
                printf("PC:%d | MUL 100 102 | Before: mem[100]=%u, mem[102]=%u -> After: mem[100]=%u, mem[102]=%u\n", 
                       PC, mem[100], mem[102], res, mem[102]);
                mem[100] = res;
                PC++;
                break;

            case 3: // SRLi 102 1
                res = mem[102] >> 1;
                printf("PC:%d | SRLi 102 1 | Before: mem[102]=%u, Imm=1 -> After: mem[102]=%u\n", 
                       PC, mem[102], res);
                mem[102] = res;
                PC++;
                break;

            case 4: // CP 104 100
                res = mem[100];
                printf("PC:%d | CP 104 100 | Before: mem[104]=%u, mem[100]=%u -> After: mem[104]=%u, mem[100]=%u\n", 
                       PC, mem[104], mem[100], res, mem[100]);
                mem[104] = res;
                PC++;
                break;

            case 5: // ADDi 104 5
                res = mem[104] + 5;
                printf("PC:%d | ADDi 104 5 | Before: mem[104]=%u, Imm=5 -> After: mem[104]=%u\n", 
                       PC, mem[104], res);
                mem[104] = res;
                PC++;
                break;

            case 6: // NAND 104 108
                res = ~(mem[104] & mem[108]);
                printf("PC:%d | NAND 104 108 | Before: mem[104]=%u, mem[108]=%u -> After: mem[104]=%u, mem[108]=%u\n", 
                       PC, mem[104], mem[108], res, mem[108]);
                mem[104] = res;
                PC++;
                break;

            case 7: // NANDi 104 5
                res = ~(mem[104] & 5);
                printf("PC:%d | NANDi 104 5 | Before: mem[104]=%u, Imm=5 -> After: mem[104]=%u\n", 
                       PC, mem[104], res);
                mem[104] = res;
                PC++;
                break;

            case 8: // SRL 108 102
                res = mem[108] >> mem[102];
                printf("PC:%d | SRL 108 102 | Before: mem[108]=%u, mem[102]=%u -> After: mem[108]=%u, mem[102]=%u\n", 
                       PC, mem[108], mem[102], res, mem[102]);
                mem[108] = res;
                PC++;
                break;

            case 9: // MULi 108 3
                res = mem[108] * 3;
                printf("PC:%d | MULi 108 3 | Before: mem[108]=%u, Imm=3 -> After: mem[108]=%u\n", 
                       PC, mem[108], res);
                mem[108] = res;
                PC++;
                break;

            case 10: // ADD 110 103
                res = mem[110] + mem[103];
                printf("PC:%d | ADD 110 103 | Before: mem[110]=%u, mem[103]=%u -> After: mem[110]=%u, mem[103]=%u\n", 
                       PC, mem[110], mem[103], res, mem[103]);
                mem[110] = res;
                PC++;
                break;

            case 11: // CP 112 110
                res = mem[110];
                printf("PC:%d | CP 112 110 | Before: mem[112]=%u, mem[110]=%u -> After: mem[112]=%u, mem[110]=%u\n", 
                       PC, mem[112], mem[110], res, mem[110]);
                mem[112] = res;
                PC++;
                break;

            case 12: // LT 112 111
                res = (mem[112] < mem[111]) ? 1 : 0;
                printf("PC:%d | LT 112 111 | Before: mem[112]=%u, mem[111]=%u -> After: mem[112]=%u, mem[111]=%u\n", 
                       PC, mem[112], mem[111], res, mem[111]);
                mem[112] = res;
                PC++;
                break;

            case 13: 
                printf("PC:%d | BZJ 111 112 | Check: mem[112]=%u -> ", PC, mem[112]);
                if (mem[112] == 0) {
                    printf("Result: Jump to mem[111]=%u\n", mem[111]);
                    PC = mem[111]; 
                } else {
                    printf("Result: No Jump\n");
                    PC++;
                }
                break;

            case 14: 
                printf("PC:%d | BZJi 101 11 | Check: mem[101]=%u -> ", PC, mem[101]);
                if (mem[101] == 0) {
                    printf("Result: Jump to 11\n");
                    PC = 11;
                } else {
                    printf("Result: No Jump\n");
                    PC++;
                }
                break;

            case 19: // MULi 101 3
                res = mem[101] * 3;
                printf("PC:%d | MULi 101 3 | Before: mem[101]=%u, Imm=3 -> After: mem[101]=%u\n", 
                       PC, mem[101], res);
                mem[101] = res;
                PC++;
                break;

            case 20: // CP 105 102
                res = mem[102];
                printf("PC:%d | CP 105 102 | Before: mem[105]=%u, mem[102]=%u -> After: mem[105]=%u, mem[102]=%u\n", 
                       PC, mem[105], mem[102], res, mem[102]);
                mem[105] = res;
                PC++;
                break;

            case 21: // LTi 105 2
                res = (mem[105] < 2) ? 1 : 0;
                printf("PC:%d | LTi 105 2 | Before: mem[105]=%u, Imm=2 -> After: mem[105]=%u\n", 
                       PC, mem[105], res);
                mem[105] = res;
                PC++;
                break;

            case 22: 
                printf("PC:%d | BZJ 113 105 | Check: mem[105]=%u -> ", PC, mem[105]);
                if (mem[105] == 0) {
                    printf("Result: Jump to mem[113]=%u\n", mem[113]);
                    PC = mem[113];
                } else {
                    printf("Result: No Jump\n");
                    PC++;
                }
                break;
            
            case 35: 
                printf("PC:%d | BZJi 111 53 | Check: mem[111]=%u -> ", PC, mem[111]);
                if (mem[111] == 0) {
                    printf("Result: Jump to 53\n");
                    PC = 53;
                } else {
                    printf("Result: No Jump\n");
                    PC++;
                }
                break;

            case 54: // CPIi 114 111
                printf("PC:%d | CPIi 114 111 | Before: mem[114]=%u, mem[111]=%u -> After: mem[114]=%u, mem[111]=%u, Target mem[%u]=%u\n", 
                       PC, mem[114], mem[111], mem[114], mem[111], mem[114], mem[111]);
                mem[mem[114]] = mem[111]; 
                PC++;
                break;

            case 55: // CPI 121 102
                res = mem[mem[102]];
                printf("PC:%d | CPI 121 102 | Before: mem[121]=%u, Ptr mem[102]=%u -> After: mem[121]=%u, mem[102]=%u\n", 
                       PC, mem[121], mem[102], res, mem[102]);
                mem[121] = res;
                running = false; 
                break;

            default:
                PC++;
                break;
        }
    }
    return 0;
}