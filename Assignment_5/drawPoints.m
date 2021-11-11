function [] = drawPoints(t,q)

    for i=1:size(q,2)

        plot(t(i),q(i), '.', 'markerSize', 15, 'color', 'r')
    end

end
