# Decoding functions
# Calc_MEG
# Pinheiro-Chagas - 2016

# Libraries
import GATclassifiers
import initDirs
# cwd = os.path.dirname(os.path.abspath(__file__))
# os.chdir(cwd)


def calcDecoding(subject, params, type):
    if type == 'class':
        # Define scorer
        scorer = 'AUC'
        print('Decoding classification')
        gat, score, diagonal = calcClassification(params['X_train'], params['y_train'], params['X_test'], params['y_test'], scorer)
    elif type == 'reg':
        # Define scorer
        scorer = 'kendall_tau'
        print('Decoding regression')
        gat, score, diagonal = calcRegression(params['X_train'], params['y_train'], params['X_test'], params['y_test'], scorer)
    print('decoding done!')

    # Organize results
    results = {'params': params,'gat': gat, 'score': score, 'diagonal': diagonal}
    print ('the size of the result is: ' + str(sys.getsizeof(results))) + 'bytes'


    # Save data
    fname = dirs['results'] + 'individual_results/' + params['subject'] + '_' + Condition[0] + '_' + Condition[
        1] + '_results_' + Type + '_' + scoreR
    # fname = result_path + '/individual_results/' + Subject + '_' + Condition[0] + '_' + Condition[1] + '_results_' + Type
    np.save(fname, results)

    return


params, times_calc, y_predictive, y_true, score, diagonal, y_train, y_test, gat_scorer, scoreR = calc_prepDec_wTask_CR(wkdir, Condition, Subject, Type)



# y_predictive = gat.y_pred_
# y_true = gat.y_true_

# 'y_predictive': y_predictive, 'y_true': y_true,
# 'score': score, 'diagonal': diagonal, 'y_train': y_train, 'y_test': y_test}