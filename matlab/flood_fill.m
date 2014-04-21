function [connected minx maxx miny maxy] = flood_fill(start, graph)
[n m] = size(graph);
minx = n;
maxx = 1;
miny = m;
maxy = 1;
connected = zeros(n, m);
connected(start(1), start(2)) = 1;
stack = cell(100, 1);
stack_cur = 1;
stack{stack_cur} = start;
stack_cur = stack_cur + 1;

deltas = [1 0; 0 1; -1 0; 0 -1];
while stack_cur > 1
    stack_cur = stack_cur - 1;
    cur = stack{stack_cur};
    for i = 1:size(deltas,1)
        next = cur + deltas(i,:);
        if graph(next(1), next(2)) && ~connected(next(1), next(2))
            connected(next(1), next(2)) = 1;
            stack{stack_cur} = next;
            stack_cur = stack_cur + 1;
            minx = min(next(1), minx);
            maxx = max(next(1), maxx);
            miny = min(next(2), miny);
            maxy = max(next(2), maxy);
        end
    end
end
end