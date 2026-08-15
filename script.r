library(tidyverse)
library(janitor)

data <- list.files(path = "data", full.names = TRUE) |>
  read_csv() |>
  clean_names() |>
  mutate(period = ceiling_date(my(period), unit = "month") - days(1))

starting <- data |>
  filter(rtt_part_type == "Part_3") |>
  select(
    period, provider_parent_org_code, provider_parent_name, provider_org_code,
    provider_org_name, commissioner_parent_org_code, commissioner_parent_name,
    commissioner_org_code, commissioner_org_name, treatment_function_code,
    treatment_function_name, total_all
  )

data <- data |>
  filter(rtt_part_type != "Part_3")

data <- data |>
  filter(treatment_function_code == "C_999") |>
  filter(rtt_part_type != "Part_2A") |>
  mutate(status = case_when(
    rtt_part_type == "Part_1A" | rtt_part_type == "Part_1B" ~ "Completed",
    rtt_part_type == "Part_2" ~ "Incomplete",
  )) |>
  summarise(
    .by = c(period, provider_org_code, status),
    week00to01 = sum(gt_00_to_01_weeks_sum_1),
    week01to02 = sum(gt_01_to_02_weeks_sum_1),
    week02to03 = sum(gt_02_to_03_weeks_sum_1),
    week03to04 = sum(gt_03_to_04_weeks_sum_1),
    week04to05 = sum(gt_04_to_05_weeks_sum_1),
    week05to06 = sum(gt_05_to_06_weeks_sum_1),
    week06to07 = sum(gt_06_to_07_weeks_sum_1),
    week07to08 = sum(gt_07_to_08_weeks_sum_1),
    week08to09 = sum(gt_08_to_09_weeks_sum_1),
    week09to10 = sum(gt_09_to_10_weeks_sum_1),
    week10to11 = sum(gt_10_to_11_weeks_sum_1),
    week11to12 = sum(gt_11_to_12_weeks_sum_1),
    week12to13 = sum(gt_12_to_13_weeks_sum_1),
    week13to14 = sum(gt_13_to_14_weeks_sum_1),
    week14to15 = sum(gt_14_to_15_weeks_sum_1),
    week15to16 = sum(gt_15_to_16_weeks_sum_1),
    week16to17 = sum(gt_16_to_17_weeks_sum_1),
    week17to18 = sum(gt_17_to_18_weeks_sum_1),
    week18to19 = sum(gt_18_to_19_weeks_sum_1),
    week19to20 = sum(gt_19_to_20_weeks_sum_1),
    week20to21 = sum(gt_20_to_21_weeks_sum_1),
    week21to22 = sum(gt_21_to_22_weeks_sum_1),
    week22to23 = sum(gt_22_to_23_weeks_sum_1),
    week23to24 = sum(gt_23_to_24_weeks_sum_1),
    week24to25 = sum(gt_24_to_25_weeks_sum_1),
    week25to26 = sum(gt_25_to_26_weeks_sum_1),
    week26to27 = sum(gt_26_to_27_weeks_sum_1),
    week27to28 = sum(gt_27_to_28_weeks_sum_1),
    week28to29 = sum(gt_28_to_29_weeks_sum_1),
    week29to30 = sum(gt_29_to_30_weeks_sum_1),
    week30to31 = sum(gt_30_to_31_weeks_sum_1),
    week31to32 = sum(gt_31_to_32_weeks_sum_1),
    week32to33 = sum(gt_32_to_33_weeks_sum_1),
    week33to34 = sum(gt_33_to_34_weeks_sum_1),
    week34to35 = sum(gt_34_to_35_weeks_sum_1),
    week35to36 = sum(gt_35_to_36_weeks_sum_1),
    week36to37 = sum(gt_36_to_37_weeks_sum_1),
    week37to38 = sum(gt_37_to_38_weeks_sum_1),
    week38to39 = sum(gt_38_to_39_weeks_sum_1),
    week39to40 = sum(gt_39_to_40_weeks_sum_1),
    week40to41 = sum(gt_40_to_41_weeks_sum_1),
    week41to42 = sum(gt_41_to_42_weeks_sum_1),
    week42to43 = sum(gt_42_to_43_weeks_sum_1),
    week43to44 = sum(gt_43_to_44_weeks_sum_1),
    week44to45 = sum(gt_44_to_45_weeks_sum_1),
    week45to46 = sum(gt_45_to_46_weeks_sum_1),
    week46to47 = sum(gt_46_to_47_weeks_sum_1),
    week47to48 = sum(gt_47_to_48_weeks_sum_1),
    week48to49 = sum(gt_48_to_49_weeks_sum_1),
    week49to50 = sum(gt_49_to_50_weeks_sum_1),
    week50to51 = sum(gt_50_to_51_weeks_sum_1),
    week51to52 = sum(gt_51_to_52_weeks_sum_1),
    week52to53 = sum(gt_52_to_53_weeks_sum_1),
    week53to54 = sum(gt_53_to_54_weeks_sum_1),
    week54to55 = sum(gt_54_to_55_weeks_sum_1),
    week55to56 = sum(gt_55_to_56_weeks_sum_1),
    week56to57 = sum(gt_56_to_57_weeks_sum_1),
    week57to58 = sum(gt_57_to_58_weeks_sum_1),
    week58to59 = sum(gt_58_to_59_weeks_sum_1),
    week59to60 = sum(gt_59_to_60_weeks_sum_1),
    week60to61 = sum(gt_60_to_61_weeks_sum_1),
    week61to62 = sum(gt_61_to_62_weeks_sum_1),
    week62to63 = sum(gt_62_to_63_weeks_sum_1),
    week63to64 = sum(gt_63_to_64_weeks_sum_1),
    week64to65 = sum(gt_64_to_65_weeks_sum_1),
    week65to66 = sum(gt_65_to_66_weeks_sum_1),
    week66to67 = sum(gt_66_to_67_weeks_sum_1),
    week67to68 = sum(gt_67_to_68_weeks_sum_1),
    week68to69 = sum(gt_68_to_69_weeks_sum_1),
    week69to70 = sum(gt_69_to_70_weeks_sum_1),
    week70to71 = sum(gt_70_to_71_weeks_sum_1),
    week71to72 = sum(gt_71_to_72_weeks_sum_1),
    week72to73 = sum(gt_72_to_73_weeks_sum_1),
    week73to74 = sum(gt_73_to_74_weeks_sum_1),
    week74to75 = sum(gt_74_to_75_weeks_sum_1),
    week75to76 = sum(gt_75_to_76_weeks_sum_1),
    week76to77 = sum(gt_76_to_77_weeks_sum_1),
    week77to78 = sum(gt_77_to_78_weeks_sum_1),
    week78to79 = sum(gt_78_to_79_weeks_sum_1),
    week79to80 = sum(gt_79_to_80_weeks_sum_1),
    week80to81 = sum(gt_80_to_81_weeks_sum_1),
    week81to82 = sum(gt_81_to_82_weeks_sum_1),
    week82to83 = sum(gt_82_to_83_weeks_sum_1),
    week83to84 = sum(gt_83_to_84_weeks_sum_1),
    week84to85 = sum(gt_84_to_85_weeks_sum_1),
    week85to86 = sum(gt_85_to_86_weeks_sum_1),
    week86to87 = sum(gt_86_to_87_weeks_sum_1),
    week87to88 = sum(gt_87_to_88_weeks_sum_1),
    week88to89 = sum(gt_88_to_89_weeks_sum_1),
    week89to90 = sum(gt_89_to_90_weeks_sum_1),
    week90to91 = sum(gt_90_to_91_weeks_sum_1),
    week91to92 = sum(gt_91_to_92_weeks_sum_1),
    week92to93 = sum(gt_92_to_93_weeks_sum_1),
    week93to94 = sum(gt_93_to_94_weeks_sum_1),
    week94to95 = sum(gt_94_to_95_weeks_sum_1),
    week95to96 = sum(gt_95_to_96_weeks_sum_1),
    week96to97 = sum(gt_96_to_97_weeks_sum_1),
    week97to98 = sum(gt_97_to_98_weeks_sum_1),
    week98to99 = sum(gt_98_to_99_weeks_sum_1),
    week99to100 = sum(gt_99_to_100_weeks_sum_1),
    week100to101 = sum(gt_100_to_101_weeks_sum_1),
    week101to102 = sum(gt_101_to_102_weeks_sum_1),
    week102to103 = sum(gt_102_to_103_weeks_sum_1),
    week103to104 = sum(gt_103_to_104_weeks_sum_1),
    beyondWeek104 = sum(gt_104_weeks_sum_1),
    total = sum(total),
    unknownStartDate = sum(patients_with_unknown_clock_start_date),
    totalAll = sum(total_all)
  )

starting <- starting |>
  filter(treatment_function_code == "C_999") |>
  summarise(.by = c(period, provider_org_code), totalAll = sum(total_all)) |>
  mutate(status = "Started")

provider <- "H3W7Q"

data <- data |>
  filter(provider_org_code == provider) |>
  select(period, status, totalAll)

starting <- starting |>
  filter(provider_org_code == provider) |>
  select(period, status, totalAll)

bind_rows(data, starting) |>
  ggplot(aes(x = period, y = totalAll, color = status)) +
  geom_line() +
  geom_point()
