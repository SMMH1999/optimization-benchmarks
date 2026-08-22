function checkProblem7Path()
%CHECKPROBLEM7PATH Show which Problem Set2 files MATLAB is using.

files = {'EngineeringProblem','EngineeringRawObjective','EngineeringEvaluate','CostFunction'};
fprintf('Active Problem Set2 files:\n');
for k = 1:numel(files)
    resolved = which(files{k},'-all');
    if isempty(resolved)
        fprintf('  %-24s : NOT FOUND\n',files{k});
    elseif iscell(resolved)
        fprintf('  %-24s : %s\n',files{k},resolved{1});
        for j = 2:numel(resolved)
            fprintf('  %-24s   shadowed by: %s\n','',resolved{j});
        end
    else
        fprintf('  %-24s : %s\n',files{k},resolved);
    end
end

problem = EngineeringProblem(7);
[f,g,h,domainValid] = EngineeringRawObjective([80 50 0.9 2.321792260794296],7);

fprintf('\nP7 structural check:\n');
fprintf('  expected inequalities : %d\n',problem.inequalityCount);
fprintf('  returned inequalities : %d\n',numel(g));
fprintf('  returned equalities   : %d\n',numel(h));
fprintf('  domain valid          : %d\n',domainValid);
fprintf('  objective             : %.15g\n',f);
disp('  g =');
disp(g);
end
