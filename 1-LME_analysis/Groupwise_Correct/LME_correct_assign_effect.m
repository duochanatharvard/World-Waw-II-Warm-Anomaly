function Bias = LME_correct_assign_effect(lme,P)

    if P.do_random == 0

        Bias.bias_fixed  = lme.out.bias_fixed;

        if P.do_region == 1
            Bias.bias_region = lme.out.bias_region;
        end

        if P.do_season == 1
            Bias.bias_season = lme.out.bias_season;
        end

        if P.do_decade == 1
            Bias.bias_decade = lme.out.bias_decade;
        end

    else

        Bias.bias_fixed  = lme.out_rnd.bias_fixed_random(P.en,:)';

        if P.do_region == 1
            Bias.bias_region = lme.out_rnd.bias_region_rnd(:,:,P.en);
        end

        if P.do_season == 1
            Bias.bias_season = lme.out_rnd.bias_season_rnd(:,:,P.en);
        end

        if P.do_decade == 1
            Bias.bias_decade = lme.out_rnd.bias_decade_rnd(:,:,P.en);
        end

    end

    if P.do_individual == 1

        n = P.en;

        Bias.bias_fixed([1:n-1 n+1:end]) = 0;

        if P.do_region == 1
            Bias.bias_region(:,[1:n-1 n+1:end]) = 0;
        end

        if P.do_season == 1
            Bias.bias_season(:,[1:n-1 n+1:end]) = 0;
        end

        if P.do_decade == 1
            Bias.bias_decade(:,[1:n-1 n+1:end]) = 0;
        end

    end
end
