function [f,g,h,domainValid] = EngineeringRawObjective(x,problemNo)
%ENGINEERINGRAWOBJECTIVE Evaluate objective and constraints for one design.
% Inequality constraints use the convention g <= 0. Equality constraints h
% are empty for the current 13-problem set.

x = EngineeringDecode(x,problemNo);
h = zeros(1,0);
domainValid = true;

switch problemNo
    case 1
        f = 0.7854*x(1)*x(2)^2*(3.3333*x(3)^2+14.9334*x(3)-43.0934) ...
            -1.508*x(1)*(x(6)^2+x(7)^2) ...
            +7.477*(x(6)^3+x(7)^3) ...
            +0.7854*(x(4)*x(6)^2+x(5)*x(7)^2);
        g = [ ...
            -x(1)*x(2)^2*x(3)+27, ...
            -x(1)*x(2)^2*x(3)^2+397.5, ...
            -x(2)*x(6)^4*x(3)/x(4)^3+1.93, ...
            -x(2)*x(7)^4*x(3)/x(5)^3+1.93, ...
            10/x(6)^3*sqrt(16.91e6+(745*x(4)/(x(2)*x(3)))^2)-1100, ...
            10/x(7)^3*sqrt(157.5e6+(745*x(5)/(x(2)*x(3)))^2)-850, ...
            x(2)*x(3)-40, ...
            -x(1)/x(2)+5, ...
            x(1)/x(2)-12, ...
            1.5*x(6)-x(4)+1.9, ...
            1.1*x(7)-x(5)+1.9];

    case 2
        f = x(1)^2*x(2)*(x(3)+2);
        denominator = 12566*(x(2)*x(1)^3-x(1)^4);
        if abs(denominator) <= 100*eps(max(1,abs(denominator)))
            domainValid = false;
            g2 = Inf;
        else
            g2 = (4*x(2)^2-x(1)*x(2))/denominator + 1/(5108*x(1)^2)-1;
        end
        g = [ ...
            1-(x(2)^3*x(3))/(71785*x(1)^4), ...
            g2, ...
            1-140.45*x(1)/(x(2)^2*x(3)), ...
            (x(1)+x(2))/1.5-1];

    case 3
        f = 0.6224*x(1)*x(3)*x(4) + 1.7781*x(2)*x(3)^2 ...
            +3.1661*x(1)^2*x(4) + 19.84*x(1)^2*x(3);
        g = [ ...
            -x(1)+0.0193*x(3), ...
            -x(2)+0.00954*x(3), ...
            -pi*x(3)^2*x(4)-(4/3)*pi*x(3)^3+1296000, ...
            x(4)-240];

    case 4
        f = (2*sqrt(2)*x(1)+x(2))*100;
        denominator1 = sqrt(2)*x(1)^2+2*x(1)*x(2);
        denominator2 = sqrt(2)*x(2)+x(1);
        if denominator1 <= 0 || denominator2 <= 0
            domainValid = false;
            g = [Inf Inf Inf];
        else
            g = [ ...
                2*(sqrt(2)*x(1)+x(2))/denominator1-2, ...
                2*x(2)/denominator1-2, ...
                2/denominator2-2];
        end

    case 5
        f = (1/6.931-(x(3)*x(2))/(x(1)*x(4)))^2;
        g = zeros(1,0);

    case 6
        f = 0.0624*sum(x);
        g = 61/x(1)^3+37/x(2)^3+19/x(3)^3+7/x(4)^3+1/x(5)^3-1;

    case 7
        % I-Shaped Beam Deflection Design
        % Exactly two inequality constraints are defined for this benchmark.
        % Convention: g <= 0.
        b = x(1);
        hBeam = x(2);
        tw = x(3);
        tf = x(4);

        webHeight = b - 2*tf;
        inertiaDenominator = tw*webHeight^3/12 ...
            + hBeam*tf^3/6 ...
            + 2*hBeam*tf*((b-tf)/2)^2;

        stressDenominator1 = tw*webHeight^3 ...
            + 2*hBeam*tf*(4*tf^2 + 3*b*webHeight);
        stressDenominator2 = webHeight*tw^3 + 2*tf*hBeam^3;

        % Numerical-domain checks only; these do NOT create extra constraints.
        domainValid = isfinite(inertiaDenominator) && inertiaDenominator > 0 ...
            && isfinite(stressDenominator1) && abs(stressDenominator1) > eps ...
            && isfinite(stressDenominator2) && abs(stressDenominator2) > eps ...
            && webHeight > 0;

        g = zeros(1,2);
        if ~domainValid
            f = Inf;
            g(:) = Inf;
        else
            f = 5000/inertiaDenominator;

            % g1: cross-sectional area limit
            g(1) = 2*hBeam*tf + tw*webHeight - 300;

            % g2: stress limit
            g(2) = (18*b*1e4)/stressDenominator1 ...
                + (15*hBeam*1e3)/stressDenominator2 - 6;
        end

    case 8
        f = 9.8*x(1)*x(2)+2*x(1);
        % The final two bound constraints act on thickness x(2), not x(1).
        g = [ ...
            1.59-x(1)*x(2), ...
            47.4-x(1)*x(2)*(x(1)^2+x(2)^2), ...
            2/x(1)-1, ...
            x(1)/14-1, ...
            0.2/x(2)-1, ...
            x(2)/0.8-1];

    case 9
        theta = 0.25*pi;
        H = x(1); B = x(2); D = x(3); X = x(4);
        l2 = sqrt((X*sin(theta)+H)^2+(B-X*cos(theta))^2);
        l1 = sqrt((X-B)^2+H^2);
        f = 0.25*pi*D^2*(l2-l1);
        P = 1500; Q = 10000; L = 240; Mmax = 1.8e6;
        denominator = sqrt((X-B)^2+H^2);
        if denominator <= 0
            domainValid = false;
            g = [Inf Inf Inf Inf];
        else
            R = abs(-X*(X*sin(theta)+H)+H*(B-X*cos(theta)))/denominator;
            F = 0.25*pi*P*D^2;
            g = [ ...
                Q*L*cos(theta)-R*F, ...
                Q*(L-X)-Mmax, ...
                1.2*(l2-l1)-l1, ...
                0.5*D-B];
        end

    case 10
        b = x(1); depth = x(2); len = x(3); t = x(4);
        radicand = len^2-depth^2;
        if radicand < 0
            rootTerm = 0;
            domainValid = false;
        else
            rootTerm = sqrt(radicand);
        end
        denominator = b+rootTerm;
        if denominator <= 100*eps(max(1,abs(b)+abs(rootTerm)))
            domainValid = false;
            f = Inf;
        else
            f = 5.885*t*(b+len)/denominator;
        end
        g = [ ...
            -t*depth*(0.4*b+len/6)+8.94*(b+rootTerm), ...
            -t*depth^2*(0.2*b+len/12)+2.2*(8.94*(b+rootTerm))^(4/3), ...
            -t+0.0156*b+0.15, ...
            -t+0.0156*len+0.15, ...
            -t+1.05, ...
            depth-len];

    case 11
        f = 1.98+4.90*x(1)+6.67*x(2)+6.98*x(3)+4.01*x(4)+1.78*x(5)+2.73*x(7);
        Fa = 1.16-0.3717*x(2)*x(4)-0.00931*x(2)*x(10) ...
            -0.484*x(3)*x(9)+0.01343*x(6)*x(10);
        VCu = 0.261-0.0159*x(1)*x(2)-0.188*x(1)*x(8)-0.019*x(2)*x(7) ...
            +0.0144*x(3)*x(5)+0.0008757*x(5)*x(10)+0.08045*x(6)*x(9) ...
            +0.00139*x(8)*x(11)+0.00001575*x(10)*x(11);
        VCm = 0.214+0.00817*x(5)-0.131*x(1)*x(8)-0.0704*x(1)*x(9) ...
            +0.03099*x(2)*x(6)-0.018*x(2)*x(7)+0.0208*x(3)*x(8) ...
            +0.121*x(3)*x(9)-0.00364*x(5)*x(6)+0.0007715*x(5)*x(10) ...
            -0.0005354*x(6)*x(10)+0.00121*x(8)*x(11)+0.00184*x(9)*x(10) ...
            -0.02*x(2)^2;
        VCl = 0.74-0.61*x(2)-0.163*x(3)*x(8)+0.001232*x(3)*x(10) ...
            -0.166*x(7)*x(9)+0.227*x(2)^2;
        Dur = 28.98+3.818*x(3)-4.2*x(1)*x(2)+0.0207*x(5)*x(10) ...
            +6.63*x(6)*x(9)-7.7*x(7)*x(8)+0.32*x(9)*x(10);
        Dmr = 33.86+2.95*x(3)+0.1792*x(10)-5.057*x(1)*x(2) ...
            -11*x(2)*x(8)-0.0215*x(5)*x(10)-9.98*x(7)*x(8)+22*x(8)*x(9);
        Dlr = 46.36-9.9*x(2)-12.9*x(1)*x(8)+0.1107*x(3)*x(10);
        Fp = 4.72-0.5*x(4)-0.19*x(2)*x(3)-0.0122*x(4)*x(10) ...
            +0.009325*x(6)*x(10)+0.000191*x(11)^2;
        VMBP = 10.58-0.674*x(1)*x(2)-1.95*x(2)*x(8)+0.02054*x(3)*x(10) ...
            -0.0198*x(4)*x(10)+0.028*x(6)*x(10);
        VFD = 16.45-0.489*x(3)*x(7)-0.843*x(5)*x(6)+0.0432*x(9)*x(10) ...
            -0.0556*x(9)*x(11)-0.000786*x(11)^2;
        g = [Fa-1,VCu-0.32,VCm-0.32,VCl-0.32,Dur-32,Dmr-32,Dlr-32, ...
            Fp-4,VMBP-9.9,VFD-15.7];

    case 12
        f = 1.10471*x(1)^2*x(2)+0.04811*x(3)*x(4)*(14+x(2));
        p = 6000; beamLength = 14; elasticModulus = 30e6; shearModulus = 12e6;
        deltaMax = 0.25; tauMax = 13600; sigmaMax = 30000;
        moment = p*(beamLength+x(2)/2);
        radius = sqrt((x(2)/2)^2+((x(1)+x(3))/2)^2);
        polarMoment = 2*(sqrt(2)*x(1)*x(2)*(x(2)^2/12+((x(1)+x(3))/2)^2));
        if polarMoment <= 0
            domainValid = false;
            g = Inf(1,7);
        else
            tauPrime = p/(sqrt(2)*x(1)*x(2));
            tauDoublePrime = moment*radius/polarMoment;
            sigma = 6*p*beamLength/(x(4)*x(3)^2);
            delta = 4*p*beamLength^3/(elasticModulus*x(3)^3*x(4));
            criticalLoad = (4.013*elasticModulus*sqrt(x(3)^2*x(4)^6/36)/beamLength^2) ...
                *(1-0.5*(x(3)/beamLength)*sqrt(elasticModulus/(4*shearModulus)));
            tau = sqrt(tauPrime^2+2*tauPrime*tauDoublePrime*x(2)/(2*radius)+tauDoublePrime^2);
            g = [ ...
                tau-tauMax, ...
                sigma-sigmaMax, ...
                x(1)-x(4), ...
                1.10471*x(1)^2+0.04811*x(3)*x(4)*(14+x(2))-5, ...
                0.125-x(1), ...
                delta-deltaMax, ...
                p-criticalLoad];
        end

    case 13
        As = x(1); width = x(2); depth = x(3);
        f = 29.4*As+0.6*width*depth;
        g = [width/depth-4, 180+7.375*As^2/depth-As*width];

    otherwise
        error('EngineeringRawObjective:InvalidProblemNumber', ...
            'Unsupported problem number: %d.',problemNo);
end

f = double(f);
g = double(g(:).');
h = double(h(:).');

if problemNo == 7 && numel(g) ~= 2
    error('EngineeringRawObjective:P7ConstraintCount', ...
        'Problem 7 must return exactly 2 inequality constraints; received %d.', ...
        numel(g));
end
if ~isreal(f) || ~isreal(g) || ~isreal(h)
    domainValid = false;
end
end
