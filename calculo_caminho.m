clc;
clear all;
clear global;

p = 0;
while (p ~= 1)
    disp('Escolha seu ponto de partida:');
    disp('1 - Moinho Cultural');
    p = input('Digite o número correspondente ao seu ponto de partida: ');

    if p ~= 1
        disp('Este não é um ponto de partida válido, digite novamente.');
    endif
endwhile

c = 0;
while (c ~= 1)
    disp('Escolha seu ponto de chegada:');
    disp('1 - Biblioteca Municipal Juscelino Kubitschek');
    c = input('Digite o número correspondente ao seu ponto de chegada: ');

    if c ~= 1
        disp('Este não é um ponto de chegada válido, digite novamente.');
    endif
endwhile

% Velocidades máximas (em m/s) correspondentes às velocidades fornecidas
vm1 = 40/3.6;
vm2 = 50/3.6;
vm3 = 60/3.6;

% Tempo de semáforo em segundos
S1 = 15;
S2 = 20;

% Funções para calcular a intensidade de trânsito pela distância
function i1 = IT1(x)
  i1 = x * 0.001;
end

function i2 = IT2(x)
  i2 = x * 0.0025;
end

function i3 = IT3(x)
  i3 = x * 0.008;
end

% Matriz com todas as restrições e distâncias para cada trecho dos três caminhos
e = [
% Caminho 1
1, S1 * 4, IT1(2500), vm2, 2500;
2, S1 * 0, IT1(1500), vm1, 1500;
3, S1 * 9, IT1(1800), vm2, 1800;
4, S1 * 2, IT1(200), vm1, 200;

% Caminho 2
5, S2 * 2, IT2(1100), vm2, 1100;
6, S2 * 0, IT2(600), vm1, 600;
7, S2 * 1, IT2(700), vm2, 700;
8, S2 * 1, IT2(1600), vm1, 1600;
9, S2 * 9, IT2(2000), vm2, 2000;
10, S2 * 2, IT2(200), vm1, 200;

% Caminho 3
11, S2 * 0, IT3(290), vm2, 290;
12, S2 * 0, IT3(2250), vm2, 2250;
13, S2 * 0, IT3(1000), vm1, 1000;
14, S2 * 0, IT3(850), vm1, 850;
15, S2 * 0, IT3(730), vm1, 730;
16, S2 * 3, IT3(350), vm2, 350;
17, S2 * 2, IT3(540), vm3, 540;
18, S2 * 2, IT3(850), vm1, 850;
];

% Calculando o tempo gasto para percorrer a distância com as restrições (velocidade, semáforos, trânsito)
tempo_trecho = e(:,5) ./ e(:,4);
e = [e, tempo_trecho];

% Cálculo de tempo para cada caminho com restrições (somando semáforos e trânsito)
d1 = sum(e(1:4, [2, 3, 6]));
D1 = sum(d1);
d2 = sum(e(5:10, [2, 3, 6]));
D2 = sum(d2);
d3 = sum(e(11:18, [2, 3, 6]));
D3 = sum(d3);

% Cálculo da distância total de cada caminho
x1 = sum(e(1:4, [5]))
X1 = sum(x1);
x2 = sum(e(5:10, [5]));
X2 = sum(x2);
x3 = sum(e(11:18, [5]));
X3 = sum(x3);

% Calculando o tempo gasto considerando apenas a velocidade máxima (sem semáforo e sem trânsito)
tempo_velocidade_maxima = e(:,5) ./ e(:,4);
vD1 = sum(tempo_velocidade_maxima(1:4));
vD2 = sum(tempo_velocidade_maxima(5:10));
vD3 = sum(tempo_velocidade_maxima(11:18));

% Convertendo o tempo para minutos
D = [D1, D2, D3] / 60;
vD = [vD1, vD2, vD3] / 60;

% Exibindo os resultados
fprintf('Tempo da primeira rota: %.2f minutos.\n', D1/60);
fprintf('Tempo da segunda rota: %.2f minutos.\n', D2/60);
fprintf('Tempo da terceira rota: %.2f minutos.\n\n', D3/60);

fprintf('Tempo com velocidade máxima na primeira rota: %.2f minutos.\n', vD1/60);
fprintf('Tempo com velocidade máxima na segunda rota: %.2f minutos.\n', vD2/60);
fprintf('Tempo com velocidade máxima na terceira rota: %.2f minutos.\n\n', vD3/60);

fprintf('Distância da primeira rota: %.2f metros.\n', X1);
fprintf('Distância da segunda rota: %.2f metros.\n', X2);
fprintf('Distância da terceira rota: %.2f metros.\n\n', X3);


% Encontrando o caminho mais rápido com as restrições
[mD, id] = min(D);
fprintf('O caminho mais rápido é o Caminho %d com %.2f minutos.\n', id, mD);

% Plotando a velocidade em função do tempo para cada caminho usando subplot
tempo_acumulado = cumsum(e(:,6)); % Tempo total acumulado em cada trecho
velocidade_repetida = [];

figure;

for caminho = 1:3
    if caminho == 1
        indices = 1:4;
    elseif caminho == 2
        indices = 5:10;
    else
        indices = 11:18;
    end

    subplot(3,1,caminho); % 3 linhas, 1 coluna, e a posição correspondente

    for i = indices
        t_intervalo = linspace(tempo_acumulado(i) - e(i,6), tempo_acumulado(i), 100);
        v_intervalo = repmat(e(i,4), size(t_intervalo));
        velocidade_repetida = [t_intervalo', v_intervalo'];
        plot(t_intervalo, v_intervalo);

        hold on;
    end
    title(['Velocidade em função do tempo - Caminho ', num2str(caminho)]);
    xlabel('Tempo (s)');
    ylabel('Velocidade (m/s)');
    grid on;
end
