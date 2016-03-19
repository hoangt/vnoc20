function [mydemo, cleanup] = demo_rbf_rt_1
%
% Demo of hybrid RBF and regression tree method.
%
% Version 1 (special order to selections).
%

% Initialise number of chunks in mydemo.
n = 0;

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{
              'This is the demo for the rbf_rt_1 method.', ...
              '-----------------------------------------', ...
              '', ...
              'rbf_rt_1 is an algorithm for regression and classification', ...
              'which combines RBF networks, regression trees and a special', ...
              'kind of subset selection.'}}, ...
  'commands', '', ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', 'First, let''s try the method on a relatively easy 1D problem.', ...
  'commands', '', ...
  'question', 'Please choose either ''sine1'' or ''hermite''.', ...
  'optional', {{'sine1', 'hermite'}});

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'Okay, you chose ''answer''. We''ll next get an instance of', ...
              'a training set for that problem and take a look at it.'}}, ...
  'commands', {{ ...
              '[x, y, dconf] = get_data(''answer'');', ...
              'fig = get_fig(''rbf_rt_1 demo'');', ...
              'hold off', ...
              'plot(x, y, ''r*'')', ...
              '%set(gca, ''XLim'', [dconf.x1 dconf.x2])', ...
              '%set(gca, ''YLim'', [floor(min(y)) ceil(max(y))])', ...
              '%set(gca, ''XTick'', dconf.x1:dconf.x2)', ...
              '%set(gca, ''YTick'', floor(min(y)):ceil(max(y)))', ...
              '%xlabel(''x'', ''FontSize'', 16)', ...
              '%ylabel(''y'', ''FontSize'', 16, ''Rotation'', 0)'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'We''ll also get an uncorrupted (zero noise), ordered test set', ...
              'of 400 samples which we can use to judge the accuracy of', ...
              'rbf_rt_1 when we apply it to the training set.'}}, ...
  'commands', {{ ...
              'dconf.std = 0;', ...
              'dconf.ord = 1;', ...
              'dconf.p = 400;', ...
              '[xt, yt] = get_data(dconf);', ...
              'hold on', ...
              'plot(xt, yt, ''b-'', ''LineWidth'', 2)'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'Now we''ll run the method on the training set (x,y). rbf_rt_1', ...
              'will return the centres (c), radii (r) and weights (w) of an', ...
              'RBF network, together with some auxiliary information in info', ...
              'and it''s control parameters in conf. For now, we''ll let', ...
              'rbf_rt_1 choose default values for all its control parameters.', ...
              '', ...
              'This may take a few seconds.'}}, ...
  'commands', '[c, r, w, info, conf] = rbf_rt_1(x, y);', ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'So what does the model built by rbf_rt_1 predict as the outputs', ...
              'over the test set inputs (xt)? We can use rbf_dm to get the', ...
              'design matrix of the test set and then it''s just a matter of', ...
              'multiplying this by the weights.'}}, ...
  'commands', {{ ...
              'Ht = rbf_dm(xt, c, r);', ...
              'ft = Ht * w;', ...
              'plot(xt, ft, ''m-'', ''LineWidth'', 2)'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'The algorithm which rbf_rt_1 uses involves a regression tree.', ...
              'The tree itself is only used as an intermediate data structure', ...
              'on the way to producing an RBF network and is not likely to be', ...
              'an accurate predictor. Nevertheless, it can be illuminating to', ...
              'see the tree''s predictions and to this end rbf_rt_1 returns a', ...
              'tree in the info structure and the routine pred_tree is available', ...
              'to make predictions from inputs such as the xt of our test set.', ...
              'Each horizontal line in the plot corresponds to one leaf node', ...
              'in the tree.'}}, ...
  'commands', {{ ...
              'tt = pred_tree(info.tree, xt);', ...
              'hold off', ...
              'plot(x, y, ''r*'')', ...
              '%set(gca, ''XLim'', [dconf.x1 dconf.x2])', ...
              '%set(gca, ''YLim'', [floor(min(y)) ceil(max(y))])', ...
              '%set(gca, ''XTick'', dconf.x1:dconf.x2)', ...
              '%set(gca, ''YTick'', floor(min(y)):ceil(max(y)))', ...
              '%xlabel(''x'', ''FontSize'', 16)', ...
              '%ylabel(''y'', ''FontSize'', 16, ''Rotation'', 0)', ...
              'hold on', ...
              'plot(xt, tt, ''m-'', ''LineWidth'', 2)'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'Some of the tree nodes, including non-leaf nodes, are turned', ...
              'into radial basis functions in the final network. The centres', ...
              'of the functions correspond to the centres of the tree nodes', ...
              'and the function widths correspond to the node widths except', ...
              'that they are also scaled by the parameter info.scale. This', ...
              'value was choosen as the best alternative from the list in', ...
              'in conf.scales.', ...
              '', ...
              'You can see the RBFs are a mixture of wide and narrow, relecting', ...
              'the different node sizes at different levels of the tree.'}}, ...
  'commands', {{ ...
              'disp(conf.scales)', ...
              'disp(info.scale)', ...
              'hold off', ...
              'plot(xt, Ht, ''r-'')', ...
              '%set(gca, ''XLim'', [dconf.x1 dconf.x2])', ...
              '%set(gca, ''YLim'', [0 1])', ...
              '%set(gca, ''XTick'', dconf.x1:dconf.x2)', ...
              '%set(gca, ''YTick'', [0 1])', ...
              '%xlabel(''x'', ''FontSize'', 16)', ...
              '%ylabel(''h_j(x)'', ''FontSize'', 16)'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'We can alo plot the basis functions after they''ve been', ...
              'multiplied by the weights and show how they combine to', ...
              'form the model of the function. If any of the weights are', ...
              'large the vertical scale in the plot will be increased and', ...
              'it might not be so easy to see the function anymore.'}}, ...
  'commands', {{ ...
              'Bt = Ht .* w(:,ones(size(Ht,1),1))'';', ...
              '%y1 = min([min(min(Bt)) min(y)]);', ...
              '%y2 = max([max(max(Bt)) max(y)]);', ...
              '%dy = 10^floor(log10(y2 - y1));', ...
              '%y1 = dy * floor(y1 / dy);', ...
              '%y2 = dy * ceil(y2 / dy);', ...
              'hold off', ...
              'plot(x, y, ''r*'')', ...
              '%set(gca, ''XLim'', [dconf.x1 dconf.x2])', ...
              '%set(gca, ''YLim'', [y1 y2])', ...
              '%set(gca, ''XTick'', dconf.x1:dconf.x2)', ...
              '%set(gca, ''YTick'', y1:dy:y2)', ...
              '%xlabel(''x'', ''FontSize'', 16)', ...
              '%ylabel(''y'', ''FontSize'', 16, ''Rotation'', 0)', ...
              'hold on', ...
              'plot(xt, Bt, ''r-'')', ...
              'plot(xt, ft, ''m-'', ''LineWidth'', 2)'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'That completes the first example where rbf_rt_1 used default values', ...
              'for its parameters. There follows a more realistic example where', ...
              'the inputs are multidimensional and we take greater care in setting', ...
              'up the parameters.'}}, ...
  'commands', '', ...
  'question', 'Do you want to see the next example?', ...
  'optional', {{'yes', 'no'}});

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'The second example comes from Friedman''s 1991 MARS paper.', ...
              'It''s a simulated alternating current circuit with four inputs', ...
              '(resistance, frequency, impedance and capacitance) and two', ...
              'possible outputs (impedance and phase). The utility get_data', ...
              'knows about this problem so we can use it to create a training', ...
              'set of 200 samples.'}}, ...
  'commands', {{ ...
              '%close(fig)', ...
              'fconf.name = ''friedman'';', ...
              'fconf.p = 200;', ...
              '[X, y, fconf] = get_data(fconf);'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'Fortunately, the default values used by the get_data utility for', ...
              'the Friedman problem are pretty much what we want, including 1 for', ...
              'the output component (fconf.comp) which corresponds to impedance,', ...
              'the noise levels (fconf.std), no ordering (fconf.ord) and input', ...
              'normalisation turned on (fconf.norm).'}}, ...
  'commands', {{ ...
              'disp(fconf.comp)', ...
              'disp(fconf.std)', ...
              'disp(fconf.norm);'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'For the test set we need to increase the number of samples and set', ...
              'the noise to zero. Since we can''t do much plotting with 4D inputs', ...
              'we don''t need ordered or spaced-out inputs (fconf.ord).'}}, ...
  'commands', {{ ...
              'fconf.p = 5000;', ...
              'fconf.std = 0;', ...
              '[Xt, yt] = get_data(fconf);'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'Before we run rbf_rt_1 on this data set we need to think about', ...
              'setting values for its control parameters, of which there are', ...
              'three main ones. A certain amount of experience has been built', ...
              'up already with similar data sets and we''re going to use values', ...
              'which have worked well in the past.', ...
              '', ...
              'First, the model selection criterion. For this method there is', ...
              'a choice of BIC (Bayesian information criterion), GCV (generlaised', ...
              'cross-validation) or LOO (leave-one-out cross-validation, as can', ...
              'easily be verified.'}}, ...
  'commands', 'rbf_rt_1(''conf'', ''msc'')', ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'It seems that for tree-based methods in general and rbf_rt_1 in', ...
              'particular, fairly conservative model selection criteria (to', ...
              'minimise the risk of overfit) work best. Consequently we will', ...
              'choose BIC, which happens to be the default anyway.', ...
              '', ...
              'The second parameter to worry about is minimum membership (conf.minmem),', ...
              'that is, the required minimum number of samples per tree node. This', ...
              'affects how bushy the tree gets and how small the leaf nodes are.', ...
              'This is not a terribly critical parameter since it''s not the tree', ...
              'nodes as such which cause overfit but the RBFs which may or may not', ...
              'be attached to them, but it does tend to have some impact. We''ll', ...
              'set a couple of alternative values and allow the algorithm to choose', ...
              'the one which works best (gives the lowest BIC).'}}, ...
  'commands', {{ ...
              'conf.msc = ''bic'';', ...
              'conf.minmem = [4 5];'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'Thirdly, the scale parameter (conf.scales) controls how big the RBFs are', ...
              'compared to the tree nodes. Previous experience has shown that for', ...
              'Friedman''s problem a reasonable number of quite large scales works', ...
              'best, so we''ll set that up accordingly. Again, the method will pick', ...
              'the best scale from amongst these alternatives.'}}, ...
  'commands', 'conf.scales = 1.5:0.25:6;', ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'We''ve now finished setting up the parameters which have most effect', ...
              'on the method''s performance. There''s just one more parameter to set.', ...
              'Since the method may take a little while to search over the alternative', ...
              'minimum memberships and scales we''ve specified, it would be nice to get', ...
              'some feedback on it''s progress. This is achieved by turning on the', ...
              'graphical timer by setting a title for it (in conf.timer).'}}, ...
  'commands', 'conf.timer = ''demo'';', ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'We''re all ready to go now. This may take some time but watching the', ...
              'timers as they keep track of the minimum memberships and scales that', ...
              'have been processed may help keep you from getting too bored.', ...
              '', ...
              'On my 233MHz Pentium-I laptop this task takes a couple of minutes.'}}, ...
  'commands', '[C, R, w, info] = rbf_rt_1(X, y, conf);', ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'Okay we''re done at last. Hope this is worth the wait!', ...
              '', ...
              'First, lets take a look at the minimum membership and scale which', ...
              'the method found gave the lowest generalisation error for this data.'}}, ...
  'commands', {{ ...
              'disp(info.minm)', ...
              'disp(info.scale)'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', {{ ...
              'Next, let''s work out how accurate the method is on the test set.', ...
              'By the way, Friedman''s MARS program managed an average scaled', ...
              'square error of 0.12 on this problem.', ...
              '', ...
              'Did we beat it?'}}, ...
  'commands', {{ ...
              'Ht = rbf_dm(Xt, C, R);', ...
              'ft = Ht * w;', ...
              'sse = sum((yt - ft).^2);', ...
              'var = sum((yt - sum(yt)/length(yt)).^2);', ...
              'fprintf(''\n   **** scaled square error = %.2f ****\n'', sse/var)'}}, ...
  'question', '', ...
  'optional', '');

n = n + 1;
mydemo(n) = struct( ...
  'comments', 'End of rbf_rt_1 demo.', ...
  'commands', '', ...
  'question', '', ...
  'optional', '');

% Define the commands necessary to cleanup after the demo (e.g. close figures).
cleanup = 'if exist(''fig'', ''var'') if ~isempty(find(findobj(''type'',''figure'') == fig)) close(fig); end; end';