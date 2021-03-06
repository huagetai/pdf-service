<!--?xml version="1.0" encoding="UTF-8"?-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <meta charset="UTF-8">
    <title>Standard Promissory Note</title>
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            font-family: serif;
        }

        h1 {
            text-transform: uppercase;
            text-align: center;
            margin: 30px 0 80px 0;
        }

        ol {
            counter-reset: item;
            margin-left: -40px;
        }

        ol > li {
            list-style-type: none;
            counter-increment: item;
            margin-bottom: 20px;
        }

        ol > li:before {
            display: inline-block;
            font-weight: bold;
            text-align: right;
            content: counter(item) ".";
        }

        ol li > span {
            text-transform: uppercase;
            font-weight: bold;
        }

        .uppercase {
            text-transform: uppercase;
        }

        @page {
            size: 8.5in 11in portrait;
            margin: 75px 60px 100px 62px;
            @bottom-right {
                content: "Page " counter(page) " of " counter(pages);
            }
        }
    </style>
</head>
<body>
<#-- Settings -->
<#setting date_format="@ordinalDate">
<#setting locale="en_US">
<h1>Standard Promissory Note</h1>
<ol>
    <li>
        <span>The Parties.</span>
        On ${model.borrowDate?datetime("yyyy-MM-dd")?date?no_esc}, 1 individual known as ${model.borrowerFirstName}&nbsp;${model.borrowerLastName}
    <#if model.borrowerMailingAddressLine1??>
        of ${model.borrowerMailingAddressLine1},
        <#if model.borrowerMailingAddressLine2??>
        ${model.borrowerMailingAddressLine2},
        </#if>
    ${model.borrowerMailingCity}, ${model.borrowerMailingState}, ${model.borrowerMailingZip},
    </#if>
        referred to as the "Borrower",
        <p class="uppercase">Received and Promises to Pay</p>

        <p>
            1 individual known as ${model.lenderFirstName}&nbsp;${model.lenderLastName}
        <#if model.lenderMailingAddressLine1??>
            of ${model.lenderMailingAddressLine1},
            <#if model.lenderMailingAddressLine2??>
            ${model.lenderMailingAddressLine2},
            </#if>
        ${model.lenderMailingCity}, ${model.lenderMailingState}, ${model.lenderMailingZip},
            referred to as the "Lender", the sum of ${model.loanAmount?string.currency} US Dollars, referred to as the
            "Borrowed Money", with interest
            accruing on the unpaid balance at a rate of ${model.interestRate} percent (%) per annum, referred to as the
            "Interest
            Rate", beginning on ${model.borrowDate?datetime("yyyy-MM-dd")?date?no_esc} under the following terms and
            conditions:
        </#if>
        </p>
    </li>
    <li>
        <span>Payments:</span>
        The full balance of the Note, including any accrued interest and late fees, is due
        and payable on ${model.dueDate?datetime("yyyy-MM-dd")?date?no_esc}, referred to as the "Due Date". The Borrowed
        Money shall
        be re-payed via installments every month.
        <p>
            The Borrowed Money shall be repaid via installments on the ${model.monthlyDueDay?string.@ordinal?no_esc} of
            every month
            beginning on ${model.borrowDate?datetime("yyyy-MM-dd")?date?no_esc} with any remaining balance payable on
            the Due Date.
        </p>

        <p>
            If the Lender does not receive payment on-time for any installment there shall be a late payment fee
            of ${model.lateFeeAmount?string.currency} (US Dollars) every occurrence of payment being late. No matter how
            late the payment is
            made this late fee may only be charged once per occurrence.
        </p>
    </li>
    <li>
        <span>Security:</span>
    <#if model.loanType == 'UNSECURED'>
        There shall be no Security put forth by the Borrower in this promissory note.
    <#else>
        This note shall be secured under the following:
        <p>
            The Borrower agrees to provide
            <#list model.securities as security>
            ${security},
            </#list>
            referred to as the "Security", which shall transfer to the
            possession and ownership of the Lender <span>immediately</span> if this Note should be in default. The
            Security may not be sold or transferred without the Lender's consent during the course of the Note.
            If the Borrower breaches this provision, Lender may declare all sums due under this Note
            immediately due and payable, unless prohibited by applicable law.
        </p>

        <p>
            If the Borrower defaults under this Note the Lender shall have the right to obtain ownership and
            possession of the Security. The Lender shall have the sole-option to accept it as full-payment for the
            Borrowed Money without further liabilities or obligations. If the market value of the Security does
            not exceed the Borrowed Money, the Borrower shall remain liable for the balance due while
            accruing interest at the maximum rate allowed by law.
        </p>
    </#if>
    </li>
    <li>
        <span>Interest Due in the Event of Default:</span>
        In the event the Borrower Fails to pay the note in-full on the Due Date, unpaid principal shall accrue
        interest at the maximum rate allowed by law, until the Borrower is no longer in default.
    </li>
    <li>
        <span>Allocation of Payments:</span>
        Payments shall be first credited to any late fees due, then to interest due and remainder will be credited to
        principal.
    </li>
    <li>
        <span>Prepayment:</span>
        Borrower may pre-pay this Note without penalty.
    </li>
    <li>
        <span>Acceleration:</span>
        If the Borrower is in default under this Note or is in default under another provision of this Note,
        and such default is not cured within the minimum allotted time by law after written notice of such default,
        then Lender may, at its option, declare all outstanding sums owed on this Note to be immediately due and
        payable.
    <#if model.loanType == 'SECURED'>
        <p>
            This includes rights of possession to the Security mentioned in Section 3.
        </p>
    </#if>
    </li>
    <li>
        <span>Attorney's Fees and Costs:</span>
        Borrower shall pay all costs incurred by Lender in collecting sums due under this Note after a default,
        including reasonable attorneys' fees. If Lender or Borrower sues to enforce this Note or obtain a declaration
        of its rights hereunder, the prevailing party in any such proceeding shall be entitled to recover its reasonable
        attorneys' fees and costs incurred in the proceeding (including those incurred in any bankruptcy proceeding or
        appeal) from the non-prevailing party.
    </li>
    <li>
        <span>Waiver of Presentments:</span>
        Borrower waives presentment for payment, notice of dishonor, protest and notice of protest.
    </li>
    <li>
        <span>Non-Waiver:</span>
        No failure or delay by Lender is exercising Lender's rights under this Note shall be considered a waiver
        of such rights.
    </li>
    <li>
        <span>Severability:</span>
        In the event that any provision herein is determined to be void or unenforceable for any reason, such
        determination shall not affect the validity or enforceability of any other provision, all which shall
        remain in full force and effect.
    </li>
    <li>
        <span>Integration:</span>
        There are no verbal or other agreements which modify or affect the terms of this Note. This Note may
        not be modified or amended except by written agreement signed by Borrower and Lender.
    </li>
    <li>
        <span>Conflicting Terms:</span>
        The terms of the Note shall have authority and precedence over any conflicting terms in any referenced
        agreement or document.
    </li>
    <li>
        <span>Notice:</span>
        Any notice required or permitted to be given hereunder shall be given in writing and shall be delivered
        (a) in person, (b) by certified mail, postage prepaid, return receipt requested, (c) by facsimile, or
        (d) by a commercial overnight courier that guarantees next day delivery and provides a receipt, and such
        notices shall be made to the parties at the addresses listed below.
    </li>
<#if model.cosignerFirstName?? && model.cosignerLastName??>
    <li>
        <span>Guarantors:</span>
    ${model.cosignerFirstName}&nbsp;${model.cosignerLastName}, referred to as the "Guarantor", agrees to the
        liabilities and obligations on behalf of the Borrower under the terms of this Note. If the Borrower does
        not make payment, the Guarantors shall be personally responsible and is guaranteeing the payment of the
        principle, late fees, and all accrued interest under the terms of this Note.
    </li>
</#if>
    <li>
        <span>Execution:</span>
        The Borrower executes this Note as a principal and not as a surety. If there is a Co-Signer, the Borrower and
        Co-Signer shall be jointly and severally liable under this Note.
    </li>
    <li>
        <span>Governing Law:</span>
        This note shall be governed under the laws in the State of ${model.stateSigned}.
    </li>
</ol>
With my signature below, I affirm that I have read and understand this promissory note.
</body>
</html>