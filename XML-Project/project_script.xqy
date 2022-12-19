xquery version "3.1" encoding "utf-8";

declare function local:pointwise_sub($seq1 as item()*,$x as xs:double)
{
  for $el at $p in $seq1
  return $seq1[$p] - $x
};

declare function local:pointwise_square($seq1 as item()*)
{
  for $el in $seq1
  return $el*$el
};

declare function local:variance($seq as item()*) 
{
  let $mean := fn:avg($seq)
  let $norm_seq := local:pointwise_sub($seq,$mean)
  return fn:avg(local:pointwise_square($norm_seq))
};

declare function local:unbias_variance($seq as item()*) 
{
  let $N-1 := count($seq) - 1
  let $N := count($seq)
  let $Bessel_Correction := $N div $N-1
  return $Bessel_Correction * local:variance($seq)
};

declare function local:Student_tTest($X1 as item()*,$X2 as item()*)
as xs:double
{
let $n1 := fn:count($X1)
let $n2 := fn:count($X2)
let $m1 := fn:avg($X1)
let $m2 := fn:avg($X2)
let $v1 := local:unbias_variance($X1)
let $v2 := local:unbias_variance($X2)

let $t := fn:abs($m1 - $m2) div math:sqrt($v1 div $n1 + $v2 div $n2)
return $t
};

declare function local:get_df($X1 as item()*,$X2 as item()*) 
{
let $n1 := fn:count($X1)
let $n2 := fn:count($X2)
return $n1 + $n2 -2
};


declare function local:decimal_round($x as xs:double) 
{
  let $round_x := fn:round($x * math:exp10(4)) div math:exp10(4)
  return $round_x
};


let $OrdDoc := doc("parsed_corona_data.xml")
let $MonthSeq := $OrdDoc//corona_data/month_data
let $DaySeq := $OrdDoc//corona_data/month_data/day_data

return 
<html>
  <body>
    <h1>Query-Results:</h1>
    <h2>Monthly Statistics:</h2>
    <table>
      <tr>
        <th>Month:</th>
        <th>Count</th>
        
        <th>Average Number of Positive Tests</th>
        <th>Standard Deviation of Positive Tests</th>
        <th>Minimum Positive Tests</th>
        <th>Maximum Positive Tests</th>
        
        <th>Average estimated Infection Carrier</th>
        <th>Standard Deviation of estimated Infection Carriers</th>
        <th>Minimum estimated Infection Carrier</th>
        <th>Maximum estimated Infection Carrier</th>
        
        <th>Average Incidence</th>
        <th>Standard Deviation of Incidence</th>
        <th>Minimum Incidence</th>
        <th>Maximum Incidence</th>
      </tr>
{
for $month in $MonthSeq
   order by $month/@first_date
    return 
   
      <tr>
      <th>From {data($month/@first_date)} to {data($month/@last_date)}</th>
      <td>{fn:count($month/day_data)}</td>
      <td>{ local:decimal_round(fn:avg(for $day in $month/day_data return data($day/positiv_getestet))) }</td>
      <td>{ local:decimal_round(math:sqrt(local:variance(for $day in $month/day_data return data($day/positiv_getestet)))) }</td>  
      <td>{ fn:min(for $day in $month/day_data return data($day/positiv_getestet)) }</td>
      <td>{ fn:max(for $day in $month/day_data return data($day/positiv_getestet)) }</td>
      
      <td>{ local:decimal_round(fn:avg(for $day in $month/day_data return data($day/geschaetzt_infektioes))) }</td>
      <td>{ local:decimal_round(math:sqrt(local:variance( for $day in $month/day_data return data($day/geschaetzt_infektioes)))) }</td>
      <td>{ fn:min(for $day in $month/day_data return data($day/geschaetzt_infektioes)) }</td>
      <td>{ fn:max(for $day in $month/day_data return data($day/geschaetzt_infektioes)) }</td>
      
      <td>{ local:decimal_round(fn:avg(for $day in $month/day_data return data($day/inzidenz))) }</td>
      <td>{ local:decimal_round(math:sqrt(local:variance(for $day in $month/day_data return data($day/inzidenz))))}</td>
      <td>{ fn:min(for $day in $month/day_data return data($day/inzidenz)) }</td>
      <td>{ fn:max(for $day in $month/day_data return data($day/inzidenz)) }</td>
      
      
      </tr>
      
  }
  </table>
  
  
  <h2>Global Statistics:</h2>
  <table>
   <tr>
     <th>Column:</th>
     <th> Count </th>
     <th>Average Number of Positive Tests</th>
     <th>Standard Deviation of Positive Tests</th>
     <th>Minimum Positive Tests</th>
     <th>Maximum Positive Tests</th>
     
     <th>Average estimated Infection Carrier</th>
     <th>Standard Deviation of estimated Infection Carriers</th>
     <th>Minimum estimated Infection Carrier</th>
     <th>Maximum estimated Infection Carrier</th>
     
     <th>Average Incidence</th>
     <th>Standard Deviation of Incidence</th>
     <th>Minimum Incidence</th>
     <th>Maximum Incidence</th>
    </tr>
    <tr>
      <th>Value:</th>
      <td>{fn:count($DaySeq)}</td>
      <td>{ local:decimal_round(fn:avg(for $day in $DaySeq return data($day/positiv_getestet))) }</td>
      <td>{ local:decimal_round(math:sqrt(local:variance(for $day in $DaySeq return data($day/positiv_getestet)))) }</td>  
      <td>{ fn:min(for $day in $DaySeq return data($day/positiv_getestet)) }</td>
      <td>{ fn:max(for $day in $DaySeq return data($day/positiv_getestet)) }</td>
      
      <td>{ local:decimal_round(fn:avg(for $day in $DaySeq return data($day/geschaetzt_infektioes))) }</td>
      <td>{ local:decimal_round(math:sqrt(local:variance(for $day in $DaySeq return data($day/geschaetzt_infektioes)))) }</td>  
      <td>{ fn:min(for $day in $DaySeq return data($day/geschaetzt_infektioes)) }</td>
      <td>{ fn:max(for $day in $DaySeq return data($day/geschaetzt_infektioes)) }</td>
      
      <td>{ local:decimal_round(fn:avg(for $day in $DaySeq return data($day/inzidenz))) }</td>
      <td>{ local:decimal_round(math:sqrt(local:variance(for $day in$DaySeq return data($day/inzidenz)))) }</td>  
      <td>{ fn:min(for $day in $DaySeq return data($day/inzidenz)) }</td>
      <td>{ fn:max(for $day in $DaySeq return data($day/inzidenz)) }</td>
    </tr>
  </table>
  
  
  <h2> T-Test Values of New Infections for October</h2>
  <table>
   <tr>
      <th>Month</th>
      <th>t-Value</th>
      <th>Degrees of Freedom</th>
   </tr>
  {
  for $month in $MonthSeq
     order by $month/@first_date
      return 
   
      <tr>
        <th>From {data($month/@first_date)} to {data($month/@last_date)}</th>
        <td>
        {local:decimal_round(local:Student_tTest($month/day_data/positiv_getestet, 
                                                 $MonthSeq[3]/day_data/positiv_getestet))}
        </td>
        <td> {local:get_df($month/day_data/positiv_getestet, 
                           $MonthSeq[3]/day_data/positiv_getestet)}</td>
     </tr>
  }
  </table>
  
 </body>
</html>



    
   