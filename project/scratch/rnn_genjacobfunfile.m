function rnn_genjacobfunfile(JACOBIAN, func_name)

if ~exist('file_name', 'var')
    func_name = 'generated_jacobian'; 
    file_name = fullfile('functions', sprintf('%s.m', func_name)); 
end

func_text = func2str(matlabFunction(JACOBIAN)); 
func_text = strsplit(regexprep(func_text, ')', 'END', 'once'), 'END'); 
func_text = regexprep(func_text{2}, 'h(\d+)', 'h($1)');
func_text = regexprep(func_text, 'J_mat_(\d+)_(\d+)', 'J_mat($1,$2)');

fid = fopen(file_name, 'w');
fprintf(fid, 'function J = %s(h,g,J_mat) \n J = %s;\n', func_name, func_text);
fclose(fid);
end